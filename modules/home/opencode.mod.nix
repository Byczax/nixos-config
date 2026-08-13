{
  config,
  osConfig, # NixOS config, to reach the decrypted agenix secret path
  lib,
  pkgs, # Added pkgs to reference tooling binaries deterministically
  ...
}: let
  cfg = config.module.opencode;
in {
  options.module.opencode.enable = lib.mkEnableOption "Enable custom opencode config";

  config = lib.mkIf cfg.enable {
    # Ensure Node.js and LSPs are available to OpenCode on your system
    home.packages = with pkgs; [
      nodejs
      git
    ];

    programs.opencode = {
      enable = true;
      settings = {
        model = "ethz/qwen3-coder-next";

        # 1. Enable documentation & agent plugins
        plugin = [
          "opencode-firecrawl" # Scrapes web doc sites cleanly into Markdown
        ];

        # 2. Add Model Context Protocol (MCP) servers for live documentation & web fetch
        mcp = {
          fetch = {
            type = "local";
            command = ["${pkgs.nodejs}/bin/npx" "-y" "@modelcontextprotocol/server-fetch"];
            enabled = true;
          };
          # github = {
          #   type = "local";
          #   command = ["${pkgs.nodejs}/bin/npx" "-y" "@modelcontextprotocol/server-github"];
          #   enabled = true;
          #   environment = {
          #     GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_TOKEN}";
          #   };
          # };
        };

        # Global permission restrictions
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
        };

        compaction = {
          auto = true;
          buffer = 4000;
          keep = {
            tokens = 12000;
          };
        };

        provider.ethz = {
          npm = "@ai-sdk/openai-compatible";
          name = "ETHZ LLM";
          options = {
            baseURL = "http://127.0.0.1:8087/v1";
            # Read from decrypted agenix secret at runtime; opencode expands {file:...}
            apiKey = "{file:${osConfig.age.secrets.opencode-api-key.path}}";
          };
          models = {
            "qwen3-coder-next" = {
              name = "Qwen3 Coder Next";
              limit = {
                context = 65536;
                output = 8192;
              };
            };
          };
        };

        agent = {
          # 3. Dedicated Doc-Researcher Agent
          doc-researcher = {
            description = "Fetches, reads, and summarizes external documentation, API references, and library definitions";
            mode = "subagent";
            prompt = ''
              You are a documentation specialist. Your primary task is to fetch, read, and parse documentation, API signatures, and official examples using available tools.
              Summarize relevant interfaces, types, and usage examples concisely for the primary coder agent before any code generation begins.
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

          tester = {
            description = "Generates unit and integration tests for new functions";
            mode = "subagent";
            prompt = "You are a test automation engineer. Generate clean, high-coverage unit and integration tests using standard frameworks (pytest, jest, cargo test, etc.).";
          };
        };
      };
      tui.theme = "system";
    };
  };
}
