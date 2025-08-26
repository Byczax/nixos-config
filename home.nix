{ config, lib, pkgs, inputs, ... }:
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
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  
  home.sessionVariables = {
    # info where to save config files 
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    
    # inform apps that we use wayland
    NIXOS_OZONE_WL = "1";

    # suggests electron apps to use the default (wayland) backend
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    # inform that we use hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    PIPEWIRE_ENABLE = "1";

    # dark mode, but does not work :/
    #GTK_THEME_VARIANT = "dark";                   # For some GTK apps
    #QT_STYLE_OVERRIDE = "dark";           # Or just "dark" if supported
    #QT_QPA_PLATFORMTHEME = "gtk3";                # Make Qt apps follow GTK settings
  };

  # the bar on the top
  programs.waybar = import ./waybar.nix ./style.css;

  # terminal
  programs.foot = {
  	enable = true;
	  settings = {
	    main = {
	      font = "Fira Code:size=11";
	    };
      #url = {
      #  launch = "xdg-open";
      #};
	  };
  };

  # sync between phone and pc 
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # local telemetry on yourslef
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
      #package = awHyprland;
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

  # make sure that user have polish layout
  home.keyboard = {
    layout = "pl";
  };


  services.swayidle.enable = true;

  
  # hyprland stack
  module.hyprland.enable = true; 
  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  services.hyprsunset = {
    enable = true;
    transitions = {
      sunrise = {
        calendar = "*-*-* 06:00:00";
        requests = [
          [ "temperature" "6500" ]
          [ "gamma 100" ]
        ];
      };
      sunset = {
        calendar = "*-*-* 19:00:00";
        requests = [
          [ "temperature" "2500" ]
        ];
      };
    };
  };
  services.hyprpolkitagent.enable = true;
  services.hyprpaper.enable = true;

  # more zsh stuff
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
    	update = "sudo nixos-rebuild switch --flake /home/bq/nixos-config/#default";
      test_vm = "sudo nixos-rebuild build-vm --flake /home/bq/nixos-config/#default";
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

  # app menu
  programs.wofi = {
  	enable = true;
  };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.firefox = {
    enable = true;
    #profiles.default = {
    #    bookmarks = [];
    #    settings = {};
    #  };
  };

  home.packages = with pkgs; [
    fira-code #font for terminal
    prismlauncher # minecraft 
    vim # as a backup
    brightnessctl # ability to change screen brightness
    font-awesome # fancy icons
    xournalpp # notes app
    signal-desktop 
    git
    traceroute 
    (flameshot.override { enableWlrSupport = true; }) # slow screenshot with drawings
    grimblast # fast screenshot 
    xorg.xlsclients # check if app is running under X11
    inkscape-with-extensions
    btop
    libreoffice-qt6-fresh
    wl-clipboard #clipboard
    helvum # audio configuration
    qbittorrent
    unzip
    gdu # disk analyzer, better than ncdu
    logseq 
    hyprshade
    #lm_sensors #maybe I don't need it
    libqalculate #calculator
    popsicle # os burner
    opentofu

    direnv #why I have that?
    libnotify # what is this for?
        gcc # C++ let's go

    # to fulfill lazyvim plugins
    luarocks
    lazygit
    fd
    lua
    fzf

    #zathura #pdf viewer
    quickemu # virtual machines
    qemu
    virt-manager

    simple-scan # scanner

    #(pkgs.texlive.combine {
    #  inherit (pkgs.texlive)
    #    scheme-medium  # base minimal setup
    #    latex         # core LaTeX support
    #    geometry      # example extra packages
    #    xcolor
    #    amsmath
    #    fontspec
    #    hyperref
    #    moderncv
    #    polski
    #    latexmk
    #    enumitem
    #    pgf;
    #})

    hyprsunset # need to install manually

    iperf
    bitwarden

    pavucontrol # add audio control alongside helvum
    adwaita-icon-theme # icons for gnome apps

    feh
    tmux
    blender
    krita
    #vscodium
    #atom
    #freecad
    #wireshark
    joplin
    vlc
    nodejs
    tree-sitter
    imagemagick # convert images
    ripgrep
    xdotool
    hugo
    go
    notesnook

    nwg-displays
    lm_sensors
    adwaita-icon-theme
    dysk

    
  ];

  services.syncthing = {
    enable = true;
  };

  programs.vesktop = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
    extraConfig = "set selection-clipboard clipboard";
  };

  # media player 
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      save-position-on-quit="yes";
    };
  };

  # other games that are not on steam
  programs.lutris = {
    enable = true;
    winePackages = [
      pkgs.wineWow64Packages.full
    ];
  };

  # notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 4000;
      "urgency=low" = {
        "border-color" = "#313244";
        "default-timeout" = "2000";
      };
      "urgency=normal" = {
        "border-color" = "#313244";
        "default-timeout" = "5000";
      };
      "urgency=high" = {
        "border-color" = "#f38ba8";
        "text-color" = "#f38ba8";
        "default-timeout" = "0";
      };    
    };
  };

  # mail client
  programs.thunderbird = {
    enable = true;
    profiles = {};
  };

  # do I need it?
  fonts = {
    #enableDefaultPackages = true;
    fontconfig.enable = true;
   };
  
  # modules
  #nvim.enable = true;
  module.helix.enable = true;

  module.nvf.enable = true;

  #catppuccin.enable = true;
} 
