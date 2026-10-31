{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.nvf;

  # Keymap-learning helpers derived from keymaps.nix (tiers, daily drill).
  learning = import ./learning.nix {inherit lib;};

  # 3 rotating keymaps shown on the dashboard. Deterministic per day, so the
  # same three keys stay up all day and change tomorrow.
  drillFooter = lib.generators.mkLuaInline ''
    (function()
      local drills = ${learning.drillTable}
      local day = tonumber(os.date("%j"))
      local out = {"", "keys of the day"}
      for i = 0, 2 do
        local d = drills[((day * 3 + i) % #drills) + 1]
        out[#out + 1] = string.format("%-16s %s", d.key, d.desc)
      end
      return out
    end)()
  '';

  # Wrap the text ourselves before handing it to vim.notify.
  hardtimeNotify = lib.generators.mkLuaInline ''
    function(text)
      local width = math.max(30, math.min(60, vim.o.columns - 12))
      local lines, line = {}, ""
      for word in text:gmatch("%S+") do
        if line == "" then
          line = word
        elseif #line + #word + 1 > width then
          lines[#lines + 1] = line
          line = word
        else
          line = line .. " " .. word
        end
      end
      if line ~= "" then
        lines[#lines + 1] = line
      end
      vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, {
        title = "Hardtime",
        timeout = 4000,
      })
    end
  '';

  dirtytalkSrc = pkgs.fetchFromGitHub {
    owner = "psliwka";
    repo = "vim-dirtytalk";
    rev = "aa57ba90";
    sha256 = "0ikk2z9axk9hys3an3cvp7m8fwrmrxb570iw1km3yz7z9f73jdbb";
  };

  programmingSpell =
    pkgs.runCommand "dirtytalk-programming-spell" {
      nativeBuildInputs = [pkgs.neovim];
    } ''
      export HOME=$(mktemp -d)
      cat ${dirtytalkSrc}/wordlists/*.words > words.txt
      mkdir -p $out/spell
      nvim -es -u NONE -i NONE \
        -c "set encoding=utf-8" \
        -c "silent mkspell! $out/spell/programming words.txt" \
        -c "qa!"
      test -f $out/spell/programming.utf-8.spl
    '';
in {
  options.modules.nvf.enable = lib.mkEnableOption "Enable custom nvf config";

  config = lib.mkIf cfg.enable {
    # Prebuilt dirtytalk programming spell file on neovim's data spell path.
    home.file.".local/share/nvim/site/spell/programming.utf-8.spl".source = "${programmingSpell}/spell/programming.utf-8.spl";

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;
          keymaps = import ./keymaps.nix;

          # Local normal/visual keypress counter feeding `:KeyFreq`.
          extraLuaFiles = [./keyfreq.lua];
          options = import ./options.nix;

          vendoredKeymaps.enable = true;

          assistant = {
            copilot = {
              enable = false;
              cmp.enable = false;
            };
          };

          startPlugins = with pkgs.vimPlugins; [
            vimtex
            vim-jsonnet
            # vim-smali
            aw-watcher-nvim
            vim-vagrant
            vim-tmux-navigator
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
          # fzf-lua.enable = true; # Fast fuzzy finder (alternative to Telescope)
          #languages.lua.lsp.lazydev.enable = true; # Enhanced Lua development experience
          clipboard.providers.wl-copy.enable = true; # Clipboard support for Wayland (wl-copy)
          snippets.luasnip.enable = true; # Snippet engine used by completion tools

          ui.noice = {
            enable = true; # Enhanced UI for messages, cmdline, and LSP
            setupOpts.lsp.signature.enabled = true; # Show LSP signature help
          };

          autopairs.nvim-autopairs.enable = true; # Auto-close brackets, quotes, etc.
          formatter.conform-nvim = {
            enable = true; # Code formatter integration
            # setupOpts = {
            #   formatters_by_ft = {
            #     jsonnet = ["jsonnetfmt"];
            #   };
            # };
          };
          filetree.neo-tree = {
            enable = true; # Alternative file tree explorer
            setupOpts.git_status_async = true;
          };
          #filetree.nvimTree.enable = true; # File explorer on the left sidebar
          notify.nvim-notify.enable = true; # Better notification system
          dashboard.dashboard-nvim = {
            enable = true; # Startup screen/dashboard
            setupOpts.config.footer = drillFooter; # 3 keymaps to learn today
          };
          #lazy.enable = true; # Plugin lazy-loading manager
          tabline.nvimBufferline.enable = true; # Tab line with open buffers/tabs
          treesitter = {
            enable = true; # Syntax highlighting and better parsing
            # grammars = [
            #   pkgs.vimPlugins.nvim-treesitter.allGrammars
            # ];
          };

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
            languages = [
              "en"
              "pl"
              "de"
              "ru"
            ];
            programmingWordlist.enable = true;
            #vim-dirtytalk.enable = true;
            # extraSpellWords = {};
          };

          mini = {
            ai.enable = true; # Text object and surrounding enhancements
            align.enable = true;
            # animate.enable = true;
            basics.enable = true;
            bracketed.enable = true;
            bufremove.enable = true;
            clue.enable = true;
            colors.enable = true;
            comment.enable = true;
            # completion.enable = true;
            cursorword.enable = true;
            diff.enable = true;
            doc.enable = true;
            extra.enable = true;
            # files.enable = true;
            fuzzy.enable = true;
            git.enable = true;
            hipatterns.enable = true;
            # hues.enable = true;
            icons.enable = true; # Display icons using mini.nvim
            indentscope.enable = true;
            jump.enable = true;
            jump2d.enable = true;
            map.enable = true;
            misc.enable = true;
            move.enable = true;
            # notify.enable = true;
            operators.enable = true;
            # pairs.enable = true;
            pick.enable = true;
            sessions.enable = true;
            snippets.enable = true;
            splitjoin.enable = true;
            starter.enable = true;
            # statusline.enable = true;
            # surround.enable = true;
            # tabline.enable = true;
            test.enable = true;
            trailspace.enable = true;
            visits.enable = true;
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
            lightbulb.enable = false; # Code action lightbulb
            #lspsaga.enable = true; #  UI for LSP interactions
            trouble.enable = false; # LSP diagnostics viewer
            lspSignature.enable = false; # Show function signature help
            lspconfig.enable = true; # Basic LSP configuration
            lspkind.enable = true; # Icons for LSP kinds (function, var, etc.)
            nvim-docs-view.enable = true; # View LSP docs in a split window
            presets = {
              deno.enable = false;
              # astro-language-server.enable = true;
            };
          };

          binds = {
            whichKey = {
              enable = true; # Shows keybindings in popup
              setupOpts = {
                notify = true;
                preset = "helix";
              };
            };
            cheatsheet.enable = true; # In-editor keybinding cheatsheet

            # Breaks the hjkl/arrow-spam habit by suggesting the real motion.
            # Start on "hint" (nags only); switch to "block" once the hints
            # stop being a surprise. Toggle at runtime with <leader>uH.
            hardtime-nvim = {
              enable = true;
              setupOpts = {
                max_count = 4;
                restriction_mode = "hint";
                disable_mouse = false;
                disabled_filetypes = ["neo-tree" "dashboard" "help" "qf" "lazygit" "TelescopePrompt"];
                callback = hardtimeNotify; # wrap the hint so it is not clipped
              };
            };
          };

          # comments = {
          #   comment-nvim.enable = true; # Toggle comments easily with `gc`
          # };
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
            enableDAP = false;
            enableTreesitter = true;

            ### languages
            assembly.enable = false;
            # astro = {
            #   enable = true;
            #   lsp.enable = true;
            #   format.enable = true;
            # };
            bash = {
              enable = true;
              lsp.enable = true;
            };
            clang.enable = false;
            clojure.enable = false;
            csharp.enable = false;

            css = {
              enable = true;
              lsp.enable = true;
            };
            cue.enable = false;
            dart = {
              enable = false;
              lsp.enable = false;
            };
            elixir.enable = false;
            fsharp.enable = false;
            gleam.enable = false;
            go = {
              enable = true;
              treesitter.enable = true;
              lsp.enable = true;
              format.enable = false; # lsp handles formatting
              dap.enable = true;
            };
            haskell.enable = false;
            hcl = {
              # terraform language
              enable = true;
              lsp.enable = true;
            };
            helm = {
              enable = true;
              lsp.enable = true;
            };
            html = {
              enable = true;
              lsp.enable = true;
            };
            java = {
              enable = false;
              lsp.enable = false;
            };
            json = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };
            julia.enable = false;
            just.enable = false;
            kotlin.enable = false;
            lua = {
              enable = false;
              lsp.enable = false;
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
            nim.enable = false;
            nix = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
              extraDiagnostics.enable = true;
              treesitter.enable = true;
            };
            nu.enable = false;
            ocaml.enable = false;
            odin.enable = false;
            php.enable = false;
            python = {
              enable = true;
              lsp.enable = true;
              dap.enable = true;
              format.enable = true;
            };
            qml.enable = false;
            r.enable = false;
            ruby.enable = false;
            rust = {
              enable = true;
              lsp.enable = true;
              dap.enable = true;
              extensions = {
                crates-nvim = {
                  enable = true;
                  setupOpts = {
                    completion.crates.enabled = true;
                    lsp = {
                      actions = true;
                      completion = true;
                      enabled = true;
                      hover = true;
                    };
                  };
                };
              };
              format.enable = true;
            };
            scala.enable = false;
            scss = {
              enable = false;
              format.enable = false;
            };
            sql = {
              enable = false;
              lsp.enable = false;
            };
            svelte.enable = false;
            # tailwind = {
            # enable = true;
            # lsp.enable = true;
            # };
            terraform = {
              enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            };
            typescript = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            typst = {
              enable = true;
              lsp.enable = true;
            };
            vala.enable = false;
            wgsl.enable = false;
            yaml = {
              enable = true;
              lsp.enable = true;
            };
            zig.enable = false;
          };
          utility = {
            vim-wakatime.enable = true; # Track coding activity
            motion.flash-nvim.enable = true; # Enhanced movement/navigation
            # Virtual-text hints showing where each motion would land.
            # Toggle with <leader>uP.
            motion.precognition = {
              enable = true;
              setupOpts = {
                startVisible = true;
                showBlankVirtLine = false;
                # Without this every f/t target on the line gets a label, so the
                # virtual line reads "0 wffetftffff tftf t$" instead of the
                # handful of motions worth seeing. Off = "0 ^ b w e $".
                targetedMotionHints.enabled = false;
                disabled_fts = ["startify" "dashboard" "neo-tree" "help" "qf"];
              };
            };
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
                # notify.enable = true; # Utilities for vim.notify
                # picker.enable = true; # Item picker UI
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
            smart-splits.enable = true;
            surround.enable = true;
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
            # aw-watcher = {
            #   package = pkgs.vimUtils.buildVimPlugin {
            #     pname = "aw-watcher";
            #     version = "master";
            #     src = pkgs.fetchFromGitHub {
            #       owner = "lowitea";
            #       repo = "aw-watcher.nvim";
            #       rev = "master";
            #       hash = "sha256-JqNQg7Kxkri92aWx8ceVguvO9j6E8V4PoCKezu0wn6w=";
            #     };
            #   };
            # };
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
