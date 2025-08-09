{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nvf;
in {
  options.nvf.enable = lib.mkEnableOption "Enable custom nvf config";

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;
          keymaps = import ./keymaps.nix;
          options = import ./options.nix;

          globals = {
            mapleader = " "; # Global leader key for mappings
            maplocalleader = "\\"; # Local leader key for mappings
            autoformat = true;
            snacks_animate = true; # Enable animations in snacks-nvim
            lazyvim_picker = "auto"; # Automatically choose a picker for LazyVim
            lazyvim_cmp = "auto"; # Automatically choose completion engine
            trouble_lualine = true; # Integrate Trouble diagnostics with Lualine
            markdown_recommended_style = 0; # Disable recommended Markdown style settings
          };

          theme = {
            enable = true;
            name = "tokyonight";
            style = "moon";
          };

          enableLuaLoader = true; # Speeds up loading by enabling Lua module loader

          telescope.enable = true; # Powerful fuzzy finder for files, symbols, etc.
          statusline.lualine.enable = true; # A fast and configurable statusline
          fzf-lua.enable = true; # Fast fuzzy finder (alternative to Telescope)
          languages.lua.lsp.lazydev.enable = true; # Enhanced Lua development experience
          clipboard.providers.wl-copy.enable = true; # Clipboard support for Wayland (wl-copy)
          snippets.luasnip.enable = true; # Snippet engine used by completion tools

          ui.noice = {
            enable = true; # Enhanced UI for messages, cmdline, and LSP
            setupOpts.lsp.signature.enabled = true; # Show LSP signature help
          };

          autopairs.nvim-autopairs.enable = true; # Auto-close brackets, quotes, etc.
          formatter.conform-nvim.enable = true; # Code formatter integration
          #filetree.neo-tree.enable = true; # Alternative file tree explorer
          filetree.nvimTree.enable = true; # File explorer on the left sidebar
          notify.nvim-notify.enable = true; # Better notification system
          dashboard.dashboard-nvim.enable = true; # Startup screen/dashboard
          lazy.enable = true; # Plugin lazy-loading manager
          tabline.nvimBufferline.enable = true; # Tab line with open buffers/tabs
          treesitter.enable = true; # Syntax highlighting and better parsing

          debugger.nvim-dap = {
            enable = true; # Enable Debug Adapter Protocol support
            ui.enable = true; # UI for nvim-dap
          };

          autocomplete = {
            blink-cmp = {
              enable = true; # Modern completion plugin alternative to nvim-cmp
              friendly-snippets.enable = true; # Predefined code snippets
            };
          };

          spellcheck = {
            enable = true; 
            languages = [ "en" "pl" "de" "ru" ];
          };

          diagnostics = {
            nvim-lint = {
              enable = true; # Linter integration for real-time feedback
            };
          };

          utility = {
            vim-wakatime.enable = true; # Track coding activity
            motion.flash-nvim.enable = true; # Enhanced movement/navigation
            snacks-nvim = {
              enable = true; # Collection of mini-tools to boost productivity
              setupOpts = {
                bigfile.enable = true; # Handle large files efficiently
                # dashboard.enable = false; # Dashboard from snacks
                explorer.enable = true; # File explorer
                input.enable = true; # Enhanced input prompts
                quickfile.enable = true; # Quick-access recent files
                scope.enable = true; # Tab/workspace scope management
                scroll.enable = true; # Smooth scrolling
                statuscolumn.enable = true; # Enhanced gutter/status column
                words.enable = true; # Word highlighting/navigation
                notifier.enable = true; # Notification framework
                # picker.enable = true; # Enhanced picker integration
                # image.enable = false; # Image preview in buffer
              };
            };
          };

          mini = {
            ai.enable = true; # Text object and surrounding enhancements
            icons.enable = true; # Display icons using mini.nvim
          };

          git = {
            enable = true; # Git integration
            gitsigns.enable = true; # Git signs in gutter (add/delete/change)
          };

          terminal = {
            toggleterm = {
              enable = true; # Floating terminal integration
              lazygit.enable = true; # Git UI tool inside toggleterm
            };
          };

          lsp = {
            enable = true; # Enable LSP features
            formatOnSave = true; # Format files when saving
            lightbulb.enable = false; #  Code action lightbulb
            lspsaga.enable = false; #  UI for LSP interactions
            trouble.enable = false; #  LSP diagnostics viewer
            lspSignature.enable = false; #  Show function signature help
            lspconfig.enable = true; # Basic LSP configuration
            lspkind.enable = true; # Icons for LSP kinds (function, var, etc.)
            nvim-docs-view.enable = true; # View LSP docs in a split window
          };

          binds = {
            whichKey.enable = true; # Shows keybindings in popup
            cheatsheet.enable = true; # In-editor keybinding cheatsheet
            # hardtime-nvim.enable = true; # Prevent bad habits by limiting repeated keys
          };

          comments = {
            comment-nvim.enable = true; # Toggle comments easily with `gc`
          };

          # startPlugins = [
            # "plenary-nvim" # Dependency for many Lua plugins
          # ];

          extraPlugins = {
            vimtex = { # latex support in nvim
              package = pkgs.vimUtils.buildVimPlugin {
                pname = "vimtex";
                version = "master";
                src = pkgs.fetchFromGitHub {
                  owner = "lervag";
                  repo = "vimtex";
                  rev = "master";
                  sha256 = "fwDUEsOrDBO+LOWiExu9EEe9oNoejYtt5JWN5AW4i0c=";
                };
              };
              setup = ''
                vim.g.vimtex_view_method = 'zathura' 
                vim.g.vimtex_compiler_method = 'latexmk' 
              '';
            };
          };
        };
     };
    };
  };
}
