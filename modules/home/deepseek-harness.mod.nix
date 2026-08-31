# FULLY LLM GENERATED
{
  config,
  osConfig, # NixOS config, to reach the decrypted agenix secret path
  lib,
  pkgs, # Tooling binaries passed deterministically
  ...
}: let
  cfg = config.modules.deepseek-harness;

  dshHome = "${config.home.homeDirectory}/.dsh";

  secretsAvailable = osConfig.modules.secrets.enable;

  # The real provider routes, kept out of the Nix store entirely. Unlike
  # opencode, dsh has no `{file:...}` indirection for plain config values, so an
  # address cannot be a reference — it has to appear literally in a patch layer.
  # The answer is to keep that layer out of the store: this template carries
  # placeholders, the activation script below substitutes the decrypted
  # addresses into $DSH_HOME/litellm.patch.yml at 0600, and the wrapper feeds
  # that file to `dsh --patch`. Only the placeholders are world-readable.
  #
  # A patch replaces the targeted row's whole `config`, so this overlay must
  # restate every provider — it does not merge with the llm-pi-ai row in the
  # home layer, it supersedes it.
  litellmPatchTemplate = pkgs.writeText "dsh-litellm.patch.yml.in" ''
    # Written by Home Manager activation; addresses come from the agenix
    # secrets litellm-base-url and ethz-base-url.
    # Not in the Nix store: it holds both addresses in clear. Do not edit.
    - id: llm-pi-ai
      config:
        providers:
          litellm:
            displayName: LiteLLM
            # A credential *reference*: dsh resolves it per request from
            # $DSH_HOME/.env, so the token is not in this file either.
            apiKeyEnv: LITELLM_API_KEY
            api: openai-completions
            baseURL: '@LITELLM_BASE_URL@'
            streamIdleTimeoutMs: 300000
            # pi-ai cannot recognize a private endpoint's URL and would
            # otherwise address it as OpenAI itself: `developer` role for the
            # system prompt and max_completion_tokens for the output cap.
            compat:
              supportsDeveloperRole: false
              maxTokensField: max_tokens
            models:
              # Must match the `model_name` LiteLLM exposes in its router
              # config, not the upstream vendor's own name.
              - id: qwen3-coder-next
                name: Qwen3 Coder Next (LiteLLM)
                contextWindow: 262144
                maxTokens: 8192

          # Restated from the home layer, which this row supersedes — and with
          # its address substituted here too, for the same reason.
          ethz:
            displayName: ETHZ LLM (llama-server)
            apiKeyEnv: ETHZ_API_KEY
            api: openai-completions
            baseURL: '@ETHZ_BASE_URL@'
            streamIdleTimeoutMs: 300000
            compat:
              supportsDeveloperRole: false
              maxTokensField: max_tokens
            models:
              - id: qwen3-coder-next
                name: Qwen3 Coder Next
                contextWindow: 262144
                maxTokens: 8192
  '';

  litellmPatchFile = "${dshHome}/litellm.patch.yml";

  # DeepSeek Harness itself. Built from source by the vendored nixpkgs
  # expression in ../../pkgs/deepseek-harness (see pkgs/default.nix); the
  # overlay is applied to every host by hosts/default.nix.
  harness = pkgs.deepseek-harness;

  # Plugins that are not part of the harness dependency closure. `dsh plugin`
  # forwards to pnpm inside $DSH_HOME/profiles/web, and any patch row naming
  # one of these fails profile boot loud until it is installed — so the wrapper
  # below installs them before the first launch and after every harness bump.
  profilePlugins = [
    "@deepseek-ai/dsh-lsp" # ctx.lsp seam
    "@deepseek-ai/dsh-lsp-stdio" # stdio language-server backend
    "@deepseek-ai/dsh-tool-lsp" # model-facing `lsp` tool
    "@deepseek-ai/dsh-tool-session-query" # search across earlier sessions
  ];

  # Everything the agent shells out to. dsh runs tools through a sandbox that
  # inherits this PATH, so the model only ever sees Nix-pinned binaries.
  toolchain = with pkgs; [
    # Runtime & package management (`dsh plugin` forwards to pnpm)
    nodejs
    pnpm
    uv # runs Python MCP servers (git, fetch) via uvx

    # Discovery
    git
    ripgrep
    fd
    ast-grep # structural code search via syntax trees
    jq
    tree
    gh

    # Formatters
    alejandra # Nix
    prettier # JS/TS/JSON/MD/YAML/CSS
    shfmt # Shell

    # Linters / static checkers
    shellcheck
    statix # Nix lint
    deadnix # Nix dead-code

    # Language servers (wired into the lsp-stdio row below)
    nil # Nix
    typescript-language-server
    vscode-langservers-extracted # HTML/CSS/JSON
    pyright # Python
    rust-analyzer # Rust
    gopls # Go
  ];

  # Re-runs the (network-touching) plugin install only when the harness build
  # or the plugin set actually changes, so every other launch is offline.
  provisionStamp =
    builtins.hashString "sha256" ("${harness}" + toString profilePlugins);

  dsh = pkgs.writeShellScriptBin "dsh" ''
    set -eu

    export DSH_HOME="''${DSH_HOME:-${dshHome}}"
    export PATH="${lib.makeBinPath (toolchain ++ [pkgs.python3 pkgs.coreutils])}:$PATH"
    # A 256k llama-server context produces large tool-result graphs; the default
    # V8 old-space is not enough and shows up as GC stalls mid-turn.
    export NODE_OPTIONS="''${NODE_OPTIONS:---max-old-space-size=8192}"
    # uv would otherwise fetch a generic-linux CPython that NixOS cannot run
    # (dynamic-linker/stub-ld error).
    export UV_PYTHON_DOWNLOADS="never"

    install -d -m 700 "$DSH_HOME"

    stamp="$DSH_HOME/.nix-plugins-stamp"
    if [ "$(cat "$stamp" 2>/dev/null || echo none)" != "${provisionStamp}" ]; then
      echo "dsh: installing out-of-tree profile plugins (one-off, needs network) ..." >&2
      ${harness}/bin/dsh plugin --profile web add \
        ${lib.concatStringsSep " " profilePlugins}
      printf '%s' "${provisionStamp}" > "$stamp"
    fi

    # Bare `dsh` opens the browser UI; the launcher has no default profile of
    # its own and would exit with a usage error.
    if [ "$#" -eq 0 ]; then set -- web; fi

    # The LiteLLM route, written outside the store by Home Manager activation
    # because it embeds the proxy address. `--patch` is a launcher flag, so it
    # has to precede the subcommand. `dsh plugin` only forwards to pnpm and
    # rejects unknown launcher flags, so it is left alone.
    if [ "$1" != "plugin" ] && [ -f "${litellmPatchFile}" ]; then
      # `web` is documented as an alias of `--profile web`, but it is a real
      # subcommand and rejects every parent launcher flag outright:
      #   error: web takes none of parent --profile, --patch, --dump-config ...
      # The spelled-out form is what accepts an overlay, so rewrite to it.
      if [ "$1" = "web" ]; then
        shift
        set -- --profile web "$@"
      fi
      set -- --patch "${litellmPatchFile}" "$@"
    fi

    exec ${harness}/bin/dsh "$@"
  '';
in {
  options.modules.deepseek-harness.enable =
    lib.mkEnableOption "Enable custom DeepSeek Harness (dsh) config";

  config = lib.mkIf cfg.enable {
    # `harness` itself is deliberately not installed: it owns bin/dsh too, and
    # the wrapper above is what should win in PATH.
    home.packages = toolchain ++ [dsh];

    # The home-level user patch layer. It is applied over every profile's own
    # cordis.patch.yml, is hot-reloaded on edit, and — unlike settings.yaml,
    # which the web Models page rewrites — is never written by dsh, so Nix can
    # own it outright. Rows are addressed by the id the shipped bundles use;
    # a patch replaces the targeted row's whole `config` rather than merging.
    home.file.".dsh/cordis.patch.yml".text = ''
      # Auto-generated by Nix Home Manager (modules/home/deepseek-harness.mod.nix).
      # Do not edit: rebuild instead. Per-machine, applies to every profile.

      # ── model route ──────────────────────────────────────────────────────
      # The deployment default for Agents created without a session-local pick.
      - id: agent-default-model
        config:
          provider: ${
        if secretsAvailable
        then "litellm"
        else "ethz"
      }
          model: qwen3-coder-next

      # The pi-ai multi-provider adapter ships dormant (zero routes). This is a
      # hand-declared route: pi-ai's catalog knows nothing under this key, so
      # the profile supplies api, baseURL and the full model list. The key
      # itself never lands here — apiKeyEnv is a credential *reference* the
      # adapter resolves per request from $DSH_HOME/.env.
      #
      # This file is in the Nix store and therefore world-readable, so the row
      # below is only a placeholder: a loopback llama route that applies when
      # secrets are unavailable. With secrets present, a runtime --patch overlay
      # supersedes this whole row and supplies the real addresses for both
      # providers — see litellmPatchTemplate above.
      - id: llm-pi-ai
        config:
          providers:
            ethz:
              displayName: ETHZ LLM (llama-server)
              apiKeyEnv: ETHZ_API_KEY
              api: openai-completions
              baseURL: http://127.0.0.1:8087/v1
              streamIdleTimeoutMs: 300000
              # pi-ai cannot recognize a private endpoint's URL and would
              # otherwise address it as OpenAI itself: `developer` role for the
              # system prompt and max_completion_tokens for the output cap,
              # both of which llama-server rejects.
              compat:
                supportsDeveloperRole: false
                maxTokensField: max_tokens
              models:
                - id: qwen3-coder-next
                  name: Qwen3 Coder Next
                  contextWindow: 262144
                  maxTokens: 8192

      # ── session search ───────────────────────────────────────────────────
      # The bundles ship `openAt: never`, which keeps exact reads and lineage
      # working but no full-text index. Deferring the open to the first search
      # keeps startup quiet while making past sessions searchable.
      - id: session-query-sqlite
        config:
          path: ':memory:'
          openAt: first-search

      # ── plugins mounted on top of the shipped bundles ────────────────────
      - insert:
          # Semantic code navigation: definition, references, implementations,
          # hover. `lsp` is the seam, `lsp-stdio` the local backend, `tool-lsp`
          # the model-facing tool. Servers start lazily on the first query.
          - id: lsp
            name: '@deepseek-ai/dsh-lsp'

          - id: lsp-stdio
            name: '@deepseek-ai/dsh-lsp-stdio'
            config:
              servers:
                nix:
                  command: ${pkgs.nil}/bin/nil
                  extensionToLanguage:
                    '.nix': nix
                typescript:
                  command: ${pkgs.typescript-language-server}/bin/typescript-language-server
                  args: ['--stdio']
                  extensionToLanguage:
                    '.ts': typescript
                    '.tsx': typescriptreact
                    '.js': javascript
                    '.jsx': javascriptreact
                    '.mjs': javascript
                    '.cjs': javascript
                python:
                  command: ${pkgs.pyright}/bin/pyright-langserver
                  args: ['--stdio']
                  extensionToLanguage:
                    '.py': python
                    '.pyi': python
                rust:
                  command: ${pkgs.rust-analyzer}/bin/rust-analyzer
                  extensionToLanguage:
                    '.rs': rust
                go:
                  command: ${pkgs.gopls}/bin/gopls
                  extensionToLanguage:
                    '.go': go
                json:
                  command: ${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server
                  args: ['--stdio']
                  extensionToLanguage:
                    '.json': json
                    '.jsonc': jsonc

          - id: tool-lsp
            name: '@deepseek-ai/dsh-tool-lsp'

          # Search and re-read earlier sessions from inside a turn.
          - id: tool-session-query
            name: '@deepseek-ai/dsh-tool-session-query'

          # ── MCP servers ──────────────────────────────────────────────────
          # No MCP server is enabled by default: each server command is trusted
          # executable code outside the agent sandbox. Tools appear to the model
          # as mcp__<serverName>__<rawName>.

          # Clean web page -> Markdown. Python reference server via uvx
          # (PyPI: mcp-server-fetch), NOT npm; dsh ships web_fetch disabled
          # because that provider defers SSRF protection.
          - id: mcp-fetch
            name: '@deepseek-ai/dsh-mcp-client'
            config:
              serverName: fetch
              transport: stdio
              command: ${pkgs.uv}/bin/uvx
              args: ['--python', '${pkgs.python3}/bin/python3', 'mcp-server-fetch']
              env:
                UV_PYTHON_DOWNLOADS: 'never'

          # Structured git history/blame/diff queries.
          - id: mcp-git
            name: '@deepseek-ai/dsh-mcp-client'
            config:
              serverName: git
              transport: stdio
              command: ${pkgs.uv}/bin/uvx
              args: ['--python', '${pkgs.python3}/bin/python3', 'mcp-server-git']
              env:
                UV_PYTHON_DOWNLOADS: 'never'

          - id: mcp-sequential-thinking
            name: '@deepseek-ai/dsh-mcp-client'
            config:
              serverName: sequentialthinking
              transport: stdio
              command: ${pkgs.nodejs}/bin/npx
              args: ['-y', '@modelcontextprotocol/server-sequential-thinking']

          # Live, version-accurate library docs & API signatures — the core of
          # "up to date code" instead of stale training data.
          - id: mcp-context7
            name: '@deepseek-ai/dsh-mcp-client'
            config:
              serverName: context7
              transport: streamable-http
              url: https://mcp.context7.com/mcp
    '';

    # Credential layer. dsh resolves apiKeyEnv references from the inherited
    # environment, then the managed $DSH_HOME/.credentials.yaml, then
    # <cwd>/.env, then $DSH_HOME/.env. The managed document is rejected outright
    # unless it is mode 0600, which a /nix/store symlink can never be, so the
    # key is written into the .env layer at activation time instead — the
    # decrypted secret only exists at runtime and must not enter the store.
    home.activation.dshCredentials = lib.mkIf osConfig.modules.secrets.enable (
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        install -d -m 700 "${dshHome}"
        umask 077
        envFile="${dshHome}/.env"
        : > "$envFile"
        chmod 600 "$envFile"

        # One line per credential reference used by the pi-ai routes above.
        # A missing secret warns and is skipped rather than aborting the
        # switch, so the other route still works.
        for pair in \
          "LITELLM_API_KEY=${osConfig.age.secrets.litellm-api-key.path}" \
          "ETHZ_API_KEY=${osConfig.age.secrets.opencode-api-key.path}"; do
          var="''${pair%%=*}"
          path="''${pair#*=}"
          if [ -r "$path" ]; then
            printf '%s=%s\n' "$var" "$(tr -d '\r\n' < "$path")" >> "$envFile"
          else
            warnEcho "dsh: $path unreadable; $var not written to ~/.dsh/.env"
          fi
        done

        # The provider-route overlay. Kept here rather than in the store-backed
        # home layer because it embeds both endpoint addresses in clear; the
        # wrapper passes it to `dsh --patch`.
        litellmUrlSecret=${osConfig.age.secrets.litellm-base-url.path}
        ethzUrlSecret=${osConfig.age.secrets.ethz-base-url.path}

        if [ -r "$litellmUrlSecret" ]; then
          litellmUrl="$(tr -d '\r\n' < "$litellmUrlSecret")"

          # The llama route degrades to the loopback default rather than taking
          # the LiteLLM route down with it.
          if [ -r "$ethzUrlSecret" ]; then
            ethzUrl="$(tr -d '\r\n' < "$ethzUrlSecret")"
          else
            warnEcho "dsh: $ethzUrlSecret unreadable; llama route left at loopback"
            ethzUrl="http://127.0.0.1:8087/v1"
          fi

          rm -f "${litellmPatchFile}"
          ( umask 077
            sed -e "s|@LITELLM_BASE_URL@|$litellmUrl|" \
                -e "s|@ETHZ_BASE_URL@|$ethzUrl|" ${litellmPatchTemplate} \
              > "${litellmPatchFile}" )
          chmod 600 "${litellmPatchFile}"
        else
          warnEcho "dsh: $litellmUrlSecret unreadable; provider routes not written"
          rm -f "${litellmPatchFile}"
        fi
      ''
    );
  };
}
