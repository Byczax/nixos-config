{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bq";
  home.homeDirectory = "/home/bq";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";

    NIXOS_OZONE_WL = "1";

    # suggests electron apps to use the default (wayland) backend
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
  };
  
  programs.waybar = import ./waybar.nix ./style.css;
  programs.foot = {
  	enable = true;
	  settings = {
	    main = {
	      font = "Fira Code:size=11";
	    };
	  };
  };
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    settings = {
      port = 5600;
    };
    watchers = {
      aw-watcher-afk = {
        package = pkgs.aw-watcher-afk;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };

    aw-watcher-window = {
      package = pkgs.aw-watcher-window;
      settings = {
        poll_time = 1;
        exclude_title = false;
      };
    };
    };
  };

  systemd.user.services.activitywatch-watcher-aw-watcher-afk = {
    Service = {
      ExecStartPre = "${pkgs.bash}/bin/sh -c \"while [ -z $DISPLAY ]; do ${pkgs.coreutils}/bin/sleep 5; done\"";
    };
  };

  systemd.user.services.activitywatch-watcher-aw-watcher-window = {
    Service = {
      ExecStartPre = "${pkgs.bash}/bin/sh -c \"while [ -z $DISPLAY ]; do ${pkgs.coreutils}/bin/sleep 5; done\"";
    };
  };

  home.keyboard = {
    layout = "pl";
  };

  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
    "$mod" = "SUPER";
    "$print" = "XF86SelectiveScreenshot";
    "$terminal" = "foot";
    "$fileManager" = "dolphin";
    "$menu" = "wofi -G --allow-images --show drun";
    exec-once = [
    	"$terminal"
      "waybar"
      "flameshot"
    ];
    general = {
    	gaps_in = 0;
	    gaps_out = 0;
	    border_size = 0;
    };
    input = {
	    "kb_layout"="pl";
      };
    bind = [
    	"$mod, Q, exec, $terminal"
      "$mod, C, killactive,"
      "$mod, M, exit,"
      "$mod, E, exec, $fileManager"
      "$mod, V, togglefloating,"
      "$mod, R, exec, $menu"
      "$mod, P, pseudo,"
      "$mod, J, togglesplit,"
      "$mod, L, exec, hyprlock"
      "$mod, Return, exec, $terminal"
      "$mod, $print, exec, grimblast copy area"
      ", $print, exec, flameshot gui"
      "$mod, F, exec, firefox"

      # Move focus with mod + arrow keys
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Example special workspace (scratchpad)
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      "$mod, 0, workspace, 10"
      "$mod SHIFT, 0, movetoworkspace, 10"
    ] ++ (
        builtins.concatLists (builtins.genList (i: let ws = i; in [
              "$mod, ${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
            ] ) 10)
    );
    bindm = [
    # Move/resize windows with mod + LMB/RMB and dragging
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    ];
    bindl = [
      ",switch:Lid Switch, exec, hyprlock"
    ];
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"

      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
    monitor = [
    ",preffered,auto,1"
    ];

    windowrulev2 = [
    	# Ignore maximize requests from apps. You'll probably like this.
	    "suppressevent maximize, class:.*"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];	
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
    	update = "sudo nixos-rebuild switch --flake /home/bq/nixos/#default";
	    calc = "qalc";
    };
    history.size = 100000;
    history.ignorePatterns = ["rm *" "pkill *" "cp *" "ls" ".." "l" "la"];
    oh-my-zsh = {
	    enable = true;
	    plugins = [ "git" ];
	    theme = "robbyrussell";
	   
    };
    initContent = ''
	    bindkey "^R" history-incremental-search-backward;
	    '';
  };

  programs.wofi = {
  	enable = true;
  };

  home.packages = with pkgs; [
    fira-code
    prismlauncher 
    vim
    firefox
    brightnessctl
    font-awesome
    hyprpaper
    xournalpp
    signal-desktop
    vesktop
    git
    traceroute
    (flameshot.override { enableWlrSupport = true; })
    grimblast
    xorg.xlsclients
    obs-studio
    inkscape
    btop
    libreoffice-qt6-fresh
    mpv
    wl-clipboard
    hyprshade
    helvum
    qbittorrent
    unzip
    ncdu
    logseq
    lm_sensors
    libqalculate
    wine
    winetricks
    popsicle
    opentofu
    direnv
    libnotify
    dbus
    xclip
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    gcc

    # to fulfill lazyvim plugins
    luarocks
    lazygit
    fd
    lua
    fzf
    zathura
  ];

  programs.texlive = {
    enable = true;
  };
  programs.lutris = {
    enable = true;
    winePackages = [
    pkgs.wineWow64Packages.full
    ];
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 4000;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles = {};
  };

  fonts = {
    fontconfig.enable = true;
   };
    
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
    ];
  
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  
    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim
          { name = "LuaSnip"; path = luasnip; }
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.bufremove"; path = mini-nvim; }
          { name = "mini.comment"; path = mini-nvim; }
          { name = "mini.indentscope"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.surround"; path = mini-nvim; }
        ];
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        -- 💡 Fix: Prevent Lazy from writing to doc/tags in Nix store
        local util = require("lazy.core.util")
        util.generate_doc_tags = function() end

        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { },
            -- fallback to download
            fallback = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            -- import/override with your plugins
            { import = "plugins" },
            -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
            { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
            -- { "nvim-treesitter/nvim-treesitter",  opts = function(_, opts) opts.ensure_installed = {} end, },
            { "lervag/vimtex" },
          },
        })
      '';
  };
  
  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
        c
        lua
        python
        json
        yaml
        bash
        hcl
        terraform
        css
        latex
        typst
        ])).dependencies;
      };
    in
    "${parsers}/parser";
  
  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };
}
