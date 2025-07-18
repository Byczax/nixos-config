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

  imports = [ ./modules/helix.nix ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";

    NIXOS_OZONE_WL = "1";

    # suggests electron apps to use the default (wayland) backend
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    GTK_THEME_VARIANT = "dark";                   # For some GTK apps
    QT_STYLE_OVERRIDE = "dark";           # Or just "dark" if supported
    QT_QPA_PLATFORMTHEME = "gtk3";                # Make Qt apps follow GTK settings
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
  hyprland.enable = true; 


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
    	update = "sudo nixos-rebuild switch --flake /home/bq/nixos-config/#default";
	    calc = "qalc";
      bat_protect_on = "sudo echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      bat_protect_off = "sudo echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
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
    quickemu
    xdg-utils # Trying to fix link clicking
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    gamemode

    simple-scan

    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium  # base minimal setup
        latex         # core LaTeX support
        geometry      # example extra packages
        xcolor
        amsmath
        fontspec
        hyperref
        moderncv
        polski
        latexmk
        enumitem
        pgf;
    })
  ];

  
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        #scripts = with pkgs.mpvScripts; [
        #  uosc
        #  sponsorblock
        #];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
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
    
  nvim.enable = true;
  helix.enable = true;
}
