{
  config,
  osConfig, # NixOS config, to reach the decrypted agenix secret path
  lib,
  pkgs, # Tooling binaries passed deterministically
  ...
}: let
  cfg = config.modules.opencode;
in {
  options.modules.opencode.enable = lib.mkEnableOption "Enable custom opencode config";

  config = lib.mkIf cfg.enable {
    # 1. System packages: fast search, code intel, formatters, LSP servers, execution
    home.packages = with pkgs; [
      # Runtime & discovery
      nodejs
      uv # Runs Python MCP servers (git, fetch) via uvx
      git
      ripgrep
      fd
      ast-grep # Structural code search via syntax trees
      jq # JSON slicing for tool output
      tree # Directory structure at a glance
      gh # GitHub CLI for PRs, issues, gists

      # Formatters (opencode `formatter` block below calls these)
      alejandra # Nix
      prettier # JS/TS/JSON/MD/YAML/CSS
      shfmt # Shell

      # Linters / static checkers (verifier agent invokes these)
      shellcheck
      statix # Nix lint
      deadnix # Nix dead-code

      # LSP servers (opencode `lsp` block below wires these)
      nil # Nix
      typescript-language-server
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      pyright # Python
      rust-analyzer # Rust
      gopls # Go
    ];

    programs.opencode = {
      enable = true;
      settings = {
        model = "ethz/qwen3-coder-next";
        autoupdate = false; # Deterministic, Nix-pinned toolchain

        # Load repo/house conventions into every session so generated code matches
        instructions = [
          "AGENTS.md"
          ".cursor/rules/*.md"
          "CONTRIBUTING.md"
        ];

        # 2. Plugins
        plugin = [
          "opencode-firecrawl" # Scrapes web doc sites cleanly into Markdown
        ];

        # 3. Model Context Protocol (MCP) servers for search, reasoning, git, & web
        mcp = {
          fetch = {
            # Python reference server via uvx (PyPI: mcp-server-fetch), NOT npm.
            # Force the Nix python + ban uv's generic-linux CPython download,
            # which NixOS can't run (dynamic-linker/stub-ld error).
            type = "local";
            command = ["${pkgs.uv}/bin/uvx" "--python" "${pkgs.python3}/bin/python3" "mcp-server-fetch"];
            environment.UV_PYTHON_DOWNLOADS = "never";
            enabled = true;
          };
          filesystem = {
            type = "local";
            command = ["${pkgs.nodejs}/bin/npx" "-y" "@modelcontextprotocol/server-filesystem" "."];
            enabled = true;
          };
          git = {
            # Python reference server via uvx (PyPI: mcp-server-git), NOT npm.
            # Nix python + no download — see fetch above.
            type = "local";
            command = ["${pkgs.uv}/bin/uvx" "--python" "${pkgs.python3}/bin/python3" "mcp-server-git"];
            environment.UV_PYTHON_DOWNLOADS = "never";
            enabled = true;
          };
          sequential-thinking = {
            type = "local";
            command = ["${pkgs.nodejs}/bin/npx" "-y" "@modelcontextprotocol/server-sequential-thinking"];
            enabled = true;
          };
          # Live, version-accurate library docs & API signatures. Core of
          # "up to date code" — pulls current docs instead of stale training data.
          context7 = {
            type = "remote";
            url = "https://mcp.context7.com/mcp";
            enabled = true;
          };
        };

        # 3b. Formatters — auto-run on save so emitted code lands lint-clean
        formatter = {
          alejandra = {
            command = ["${pkgs.alejandra}/bin/alejandra" "--quiet" "$FILE"];
            extensions = [".nix"];
          };
          prettier = {
            command = ["${pkgs.prettier}/bin/prettier" "--write" "$FILE"];
            extensions = [".js" ".ts" ".jsx" ".tsx" ".json" ".md" ".yaml" ".yml" ".css" ".html"];
          };
          shfmt = {
            command = ["${pkgs.shfmt}/bin/shfmt" "-w" "$FILE"];
            extensions = [".sh" ".bash"];
          };
        };

        # 3c. Language servers — give the model real diagnostics, defs, hovers
        lsp = {
          nix = {
            command = ["${pkgs.nil}/bin/nil"];
            extensions = [".nix"];
          };
          typescript = {
            command = ["${pkgs.typescript-language-server}/bin/typescript-language-server" "--stdio"];
            extensions = [".js" ".ts" ".jsx" ".tsx" ".mjs" ".cjs"];
          };
          python = {
            command = ["${pkgs.pyright}/bin/pyright-langserver" "--stdio"];
            extensions = [".py" ".pyi"];
          };
          rust = {
            command = ["${pkgs.rust-analyzer}/bin/rust-analyzer"];
            extensions = [".rs"];
          };
          go = {
            command = ["${pkgs.gopls}/bin/gopls"];
            extensions = [".go"];
          };
          json = {
            command = ["${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server" "--stdio"];
            extensions = [".json" ".jsonc"];
          };
        };

        # 4. Global safety permissions
        permission = {
          read = {
            "/tmp/*" = "deny";
            "/dev/*" = "deny";
            "/root/*" = "deny";
          };
          edit = {
            "/tmp/*" = "deny";
            "/dev/*" = "deny";
            "/root/*" = "deny";
          };
          # Let routine dev commands run; gate destructive/irreversible ones.
          bash = {
            "*" = "allow";
            "rm -rf *" = "ask";
            "git push*" = "ask";
            "git reset --hard*" = "ask";
            "sudo *" = "ask";
            "curl * | *sh" = "ask";
            "nix-collect-garbage*" = "ask";
          };
        };

        # 5. Compaction Settings (Scaled to leverage your 256k llama-server context)
        compaction = {
          auto = true;
          buffer = 8000;
          keep = {
            tokens = 48000; # Retains extensive AST structures and chat history
          };
        };

        # 6. Provider Definition
        provider.ethz = {
          npm = "@ai-sdk/openai-compatible";
          name = "ETHZ LLM";
          options = {
            baseURL = "http://127.0.0.1:8087/v1";
            apiKey = "{file:${osConfig.age.secrets.opencode-api-key.path}}";
          };
          models = {
            "qwen3-coder-next" = {
              name = "Qwen3 Coder Next";
              limit = {
                context = 262144; # Matched to 256k llama-server context limit
                output = 8192;
              };
              options = {
                temperature = 0.2; # Low = deterministic, precise code
                top_p = 0.9;
              };
            };
          };
        };

        # 7. Agent Architecture
        agent = {
          # Primary orchestrator: writes code, delegates research/review/tests.
          build = {
            description = "Primary coding agent: plans, writes, and integrates fully working code, delegating to subagents";
            mode = "primary";
            temperature = 0.2;
            prompt = ''
              You are the lead engineer driving a working implementation to completion.
              Workflow:
              1. Before writing code against any external library or API, delegate to @doc-researcher to pull current signatures via Context7 — never guess an API from memory.
              2. Write complete, runnable code. No stubs, TODOs, or placeholder logic unless the user asked for a sketch.
              3. After edits, delegate to @verifier to compile/typecheck/lint, then @tester to run tests. Repair every reported error before declaring done.
              4. For non-trivial or security-relevant changes, delegate to @reviewer and address findings.
              Match existing project conventions loaded from AGENTS.md. Prefer editing existing files over creating new ones.
            '';
          };

          # Read-only architect for scoping before large changes.
          plan = {
            description = "Read-only planner: explores the codebase and produces an implementation plan without editing";
            mode = "primary";
            prompt = ''
              You design implementation strategy. Explore the code, identify the files to touch, and lay out concrete step-by-step changes with trade-offs.
              Do NOT modify files — output a plan the build agent executes.
            '';
            permission = {
              edit = "deny";
            };
          };

          doc-researcher = {
            description = "Fetches, reads, and summarizes external documentation, API references, and library definitions";
            mode = "subagent";
            prompt = ''
              You are a documentation specialist. Fetch and parse current documentation, API signatures, and official examples using the Context7 MCP (resolve-library-id then get-library-docs), the fetch MCP, and firecrawl.
              Always prefer Context7 for version-accurate library APIs over general web text. Summarize relevant interfaces, types, and idiomatic usage concisely for the coder agent before any code generation begins.
            '';
            permission = {
              edit = "deny"; # Docs reader shouldn't modify local workspace files
            };
          };

          reviewer = {
            description = "Reviews code diffs for bugs, security vulnerabilities, and logic flaws";
            mode = "subagent";
            prompt = "You are a senior security and QA engineer. Focus strictly on code correctness, security flaws, edge cases, and maintainability. Do not make direct file modifications.";
            permission = {
              edit = "deny";
            };
          };

          verifier = {
            description = "Executes workspace linters, compilers, and static checkers to verify code correctness";
            mode = "subagent";
            prompt = ''
              You are an automated verification agent. Your job is to execute project compilers, linters, and typecheckers (e.g., `tsc`, `cargo check`, `nix flake check`, `pytest`, `eslint`).
              Report raw compilation/linter output back verbatim without modifying files directly so the primary agent can repair errors immediately.
            '';
            permission = {
              edit = "deny";
            };
          };

          tester = {
            description = "Generates unit and integration tests, running them to verify implementations";
            mode = "subagent";
            prompt = ''
              You are a test automation engineer.
              1. Generate clean, high-coverage unit and integration tests using standard frameworks (pytest, jest, cargo test, etc.).
              2. Execute test suites and feed any failure stack traces back to the primary agent for auto-correction.
            '';
          };
        };
      };
      tui.theme = "system";
    };
  };
}
