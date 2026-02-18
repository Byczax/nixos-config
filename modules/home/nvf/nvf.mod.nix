{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.nvf;
in {
  options.module.nvf.enable = lib.mkEnableOption "Enable custom nvf config";

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;
          keymaps = import ./keymaps.nix;
          options = import ./options.nix;

          startPlugins = with pkgs.vimPlugins; [
            vimtex
            vim-jsonnet
            vim-smali
            aw-watcher-nvim
            vim-vagrant
          ];

          globals = {
            mapleader = " "; # Global leader key for mappings
            maplocalleader = "\\"; # Local leader key for mappings
            autoformat = true;
            snacks_animate = true; # Enable animations in snacks-nvim
            #lazyvim_picker = "auto"; # Automatically choose a picker for LazyVim
            #lazyvim_cmp = "auto"; # Automatically choose completion engine
            trouble_lualine = true; # Integrate Trouble diagnostics with Lualine
            markdown_recommended_style = 0; # Disable recommended Markdown style settings
          };

          theme = {
            enable = true;
            name = "tokyonight";
            style = "moon";
          };

          enableLuaLoader = true; # Speeds up loading by enabling Lua module loader

          lazy = {
            enable = true;
            #plugins = {
            #  snacks-nvim = {
            #    package = "snacks-nvim";
            #    lazy = false;
            #    #setupModule = "snacks";
            #    #setupOpts = cfg.utility.snacks-nvim.setupOpts;
            #  };
            #};
          };

          telescope.enable = true; # Powerful fuzzy finder for files, symbols, etc.
          statusline.lualine.enable = true; # A fast and configurable statusline
          fzf-lua.enable = true; # Fast fuzzy finder (alternative to Telescope)
          #languages.lua.lsp.lazydev.enable = true; # Enhanced Lua development experience
          clipboard.providers.wl-copy.enable = true; # Clipboard support for Wayland (wl-copy)
          snippets.luasnip.enable = true; # Snippet engine used by completion tools

          ui.noice = {
            enable = true; # Enhanced UI for messages, cmdline, and LSP
            setupOpts.lsp.signature.enabled = true; # Show LSP signature help
          };

          autopairs.nvim-autopairs.enable = true; # Auto-close brackets, quotes, etc.
          formatter.conform-nvim.enable = true; # Code formatter integration
          filetree.neo-tree.enable = true; # Alternative file tree explorer
          #filetree.nvimTree.enable = true; # File explorer on the left sidebar
          notify.nvim-notify.enable = true; # Better notification system
          dashboard.dashboard-nvim.enable = true; # Startup screen/dashboard
          #lazy.enable = true; # Plugin lazy-loading manager
          tabline.nvimBufferline.enable = true; # Tab line with open buffers/tabs
          treesitter.enable = true; # Syntax highlighting and better parsing

          debugger.nvim-dap = {
            enable = true; # Enable Debug Adapter Protocol support
            ui.enable = true; # UI for nvim-dap
          };

          autocomplete = {
            nvim-cmp = {
              enable = false;
            };
            blink-cmp = {
              enable = true; # Modern completion plugin alternative to nvim-cmp
              friendly-snippets.enable = true; # Predefined code snippets
              setupOpts.fuzzy.implementation = "lua";
            };
          };

          spellcheck = {
            enable = true;
            languages = ["en" "pl" "de" "ru"];
          };

          mini = {
            ai.enable = true; # Text object and surrounding enhancements
            icons.enable = true; # Display icons using mini.nvim
          };

          git = {
            enable = true; # Git integration
            gitsigns.enable = true; # Git signs in gutter (add/delete/change)
            git-conflict.enable = true;
            hunk-nvim.enable = true;
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
            inlayHints.enable = true;
            lightbulb.enable = false; #  Code action lightbulb
            #lspsaga.enable = true; #  UI for LSP interactions
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
          projects = {
            project-nvim.enable = true;
          };
          session = {
            nvim-session-manager.enable = true;
          };

          #diagnostics = {
          #  nvim-lint = {
          #    enable = true; # Linter integration for real-time feedback
          #  };
          #};

          languages = {
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableTreesitter = true;
            assembly.enable = false;
            #astro = {
            #  enable = true;
            #  lsp.enable = true;
            #};
            bash = {
              enable = true;
              lsp.enable = true;
            };
            clang.enable = false;
            csharp.enable = false;

            css = {
              enable = true;
              lsp.enable = true;
            };
            dart = {
              enable = false;
              lsp.enable = false;
            };
            go = {
              enable = true;
              lsp.enable = true;
            };
            hcl = {
              enable = true;
              lsp.enable = true;
            };
            helm = {
              enable = true;
              lsp.enable = true;
            };
            html = {
              enable = true;
            };
            java = {
              enable = true;
              lsp.enable = true;
            };
            kotlin.enable = false;
            lua = {
              enable = true;
              lsp.enable = true;
            };
            markdown = {
              enable = true;
              lsp.enable = true;
              extensions = {
                #markview-nvim.enable = true;
                render-markdown-nvim.enable = true;
              };
              format.enable = true;
            };
            nix = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            php.enable = false;
            python = {
              enable = true;
              lsp.enable = true;
            };
            rust = {
              enable = true;
              lsp.enable = true;
            };
            sql = {
              enable = true;
              lsp.enable = true;
            };
            svelte.enable = false;
            tailwind = {
              enable = true;
              lsp.enable = true;
            };
            terraform = {
              enable = true;
              lsp.enable = true;
            };
            ts = {
              enable = true;
              lsp.enable = true;
            };
            typst = {
              enable = true;
              lsp.enable = true;
            };
            yaml = {
              enable = true;
              lsp.enable = true;
            };
            ruby = {
              enable = true;
              lsp.enable = true;
            };
          };

          utility = {
            vim-wakatime.enable = true; # Track coding activity
            motion.flash-nvim.enable = true; # Enhanced movement/navigation
            preview.markdownPreview.enable = true;
            snacks-nvim = {
              enable = true; # Collection of mini-tools to boost productivity
              setupOpts = {
                animate.enable = true; # Efficient animations & easing functions
                bigfile.enable = true; # Handle very large files efficiently
                bufdelete.enable = true; # Delete buffers without disturbing layout
                #dashboard.enable = true; # Beautiful startup dashboard
                debug.enable = true; # Pretty inspect & backtraces for debugging
                dim.enable = true; # Dim inactive scopes for focus
                #explorer.enable = true; # File explorer (picker-based)
                gh.enable = true; # GitHub CLI integration
                git.enable = true; # Git utilities
                gitbrowse.enable = true; # Open current file/branch in browser
                #image.enable = true; # Image preview (kitty/wezterm/ghostty)
                indent.enable = true; # Indent guides and scopes
                input.enable = true; # Enhanced vim.ui.input
                keymap.enable = true; # Better keymaps with filetype/LSP support
                layout.enable = true; # Window layouts management
                lazygit.enable = true; # Floating LazyGit integration
                notifier.enable = true; # Pretty notifications
                notify.enable = true; # Utilities for vim.notify
                picker.enable = true; # Item picker UI
                profiler.enable = true; # Lua/Neovim profiler
                quickfile.enable = true; # Quick access to files on startup
                rename.enable = true; # LSP-aware file renaming
                scope.enable = true; # Scope detection & navigation
                scratch.enable = true; # Scratch buffers
                scroll.enable = true; # Smooth scrolling
                statuscolumn.enable = true; # Enhanced gutter/status column
                terminal.enable = true; # Floating/split terminal management
                toggle.enable = true; # Toggle keymaps with which-key integration
                util.enable = true; # Snacks utility functions (library)
                win.enable = true; # Floating window management
                words.enable = true; # Word highlighting & quick navigation
                zen.enable = true; # Distraction-free Zen mode
              };
            };
          };

          extraPlugins = {
            #vimtex = {
            #  # latex support in nvim
            #  package = pkgs.vimUtils.buildVimPlugin {
            #    pname = "vimtex";
            #    version = "master";
            #    src = pkgs.fetchFromGitHub {
            #      owner = "lervag";
            #      repo = "vimtex";
            #      rev = "master";
            #      sha256 = "sha256-jwW4Ljp8wxy/lE7Xh3Fhi8XaVDLtgpD4XyA78Xa+DT4=";
            #    };
            #  };
            #  setup = ''
            #    vim.g.vimtex_view_method = 'zathura'
            #    vim.g.vimtex_compiler_method = 'latexmk'
            #    vim.g.vimtex_fzf_lua_enabled = false
            #  '';
            #};
            #typst = {
            #  package = pkgs.vimUtils.buildVimPlugin {
            #    pname = "typst";
            #    version = "master";
            #    src = pkgs.fetchFromGitHub {
            #      owner = "kaarmu";
            #      repo = "typst.vim";
            #      rev = "master";
            #      sha256 = "sha256-2FZnhkp2pN8axzrwsFy0p28vQTmmPs0eyf2j0ojovnk=";
            #    };
            #  };
            #};
            #vimjsonnet = {
            #  package = pkgs.vimUtils.buildVimPlugin {
            #    pname = "vim-jsonnet";
            #    version = "master";
            #    src = pkgs.fetchFromGitHub {
            #      owner = "google";
            #      repo = "vim-jsonnet";
            #      rev = "master";
            #      sha256 = "sha256-ChgUGTrLthuGSws/UpF71JYI/c2QqItax6hsh7mYX/w="; # replace with actual
            #    };
            #  };
            #};
            vimtanka = {
              package = pkgs.vimUtils.buildVimPlugin {
                pname = "vim-tanka";
                version = "master";
                src = pkgs.fetchFromGitHub {
                  owner = "dsabsay";
                  repo = "vim-tanka";
                  rev = "master";
                  hash = "sha256-17imEImqE8HzKhSZPL0MExY/ZXZpPTzjVzo5JGSI/0A=";
                };
              };
            };
            hadolint = {
              package = pkgs.vimUtils.buildVimPlugin {
                pname = "hadolint";
                version = "master";
                src = pkgs.fetchFromGitHub {
                  owner = "hadolint";
                  repo = "hadolint";
                  rev = "master";
                  hash = "sha256-17imEImqE8HzKhSZPL0MExY/ZXZpPTzjVzo5JGSI/0A=";
                };
              };
            };
            #vimsmali = {
            #  package = pkgs.vimUtils.buildVimPlugin {
            #    pname = "vim-smali";
            #    version = "master";
            #    src = pkgs.fetchFromGitHub {
            #      owner = "kelwin";
            #      repo = "vim-smali";
            #      rev = "master";
            #      sha256 = "sha256-2arBJ4sY+QbqkSG02bibMX22Dcr7m9Eiv3dpw5+tPb4="; # replace with actual
            #    };
            #  };
            #};
          };
        };
      };
    };
  };
}
