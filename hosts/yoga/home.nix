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
    EDITOR="nvim";

    # inform apps that we use wayland
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM="wayland";

    # suggests electron apps to use the wayland backend
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    # inform that we use hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # the bar on the top
  #programs.waybar = import ../../waybar.nix ../../style.css;

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

  home.file.".config/zoomus.conf".text = ''
    [General]
    %2B8gcPZIuASRcihpYJW6UA83rPnH%2B7ifu11s9xp3p8Rc%23=1756246768
    63tJmSFEpYg9dR34FZPBHK8VKGPcUT1yDVJWSS9UTuU%23=1756246768
    GeoLocale=system
    KXhiCZ2HpmjrAEVlAVyB4VHAVsfnyTQR06weNL9BKYY%23=1756246768
    SensitiveInfoMaskOn=true
    ShowBiDirecSyncNoti=true
    UeJ7AgrtBappnQjaaFui4jk8yVCY2K4zE14gyE34Rzo%23=1756246768
    autoPlayGif=false
    autoScale=true
    bForceMaximizeWM=false
    captureHDCamera=true
    cefInstanceCountLimit=-1
    cefRefreshTime=0
    chatListPanelLastWidth=230
    com.zoom.client.langid=0
    conf.webserver=https://eu01web.zoom.us
    conf.webserver.vendor.default=https://ethz.zoom.us
    currentMeetingId=66118033985
    deviceID=F4:A4:75:47:60:85
    disableCef=false
    enable.host.auto.grab=true
    enableAlphaBuffer=true
    enableCefGpu=false
    enableCefLog=false
    enableCefTa=false
    enableCloudSwitch=true
    enableLog=true
    enableMiniWindow=true
    enableQmlCache=true
    enableScreenSaveGuard=false
    enableStartMeetingWithRoomSystem=false
    enableTestMode=false
    enablegpucomputeutilization=false
    fake.version=
    flashChatTime=0
    forceEnableTrayIcon=true
    forceSSOURL=
    hideCrashReport=false
    host.auto.grab.interval=10
    isTransCoding=false
    jK9BkbV8zNjw7whdX9AnddbmbOu4N8hVKwVt8iDnC38%23=1756246768
    logLevel=info
    newMeetingWithVideo=true
    noSandbox=false
    pOoALJyX%2BqjXWD3Cr1Q4lH5ZpVshFjYob0SH3xBr2jQ%23=1756246768
    playSoundForNewMessage=false
    shareBarTopMargin=0
    showOneTimePTAICTipHubble=false
    showOneTimeQAMostUpvoteHubble=true
    showOneTimeQueriesOptionTip=true
    showOneTimeTranslationUpSellTip=false
    showSystemTitlebar=false
    speaker_volume=255
    sso_domain=.zoom.us
    sso_gov_domain=.zoomgov.com
    system.audio.type=default
    systemDockMargin=0
    timeFormat12HoursEnable=true
    translationFreeTrialTipShowTime=0
    upcoming_meeting_header_image=
    useSystemTheme=false
    userEmailAddress=mbyczko@ethz.ch
    webview.debug.enable=false
    xwayland=false

    [1VGa6fEsTQYEquYOdMv]
    j1V5NQSTWNQPlSB8TSaIgvM%23=1756246768

    [AS]
    showframewindow=true

    [chat.recent]
    recentlast.session=

    [e2oewir4]
    zlsEjhEtnrfV\1\RNfupD3GFHXnLPoOTzI%23=1756246768

    [p2j01nOS5WVbsNRvQFnMTmH5SbwLdPoVQxAt]
    B0jJHc%23=1756246768

    [pvKc9SrvNy]
    UrM6djKC7sBYYhjF2xNCSHVpXDpFealQ%23=1756246768

    [zoom_new_im]
    is_landscape_mode=true
    main_frame_pixel_pos_narrow="376,600"
    main_frame_pixel_pos_wide="1920,1034"
  '';
  home.file.".config/electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';



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
    	update = "sudo nixos-rebuild switch --flake /home/bq/nixos-config/#yoga";
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
    export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    export KUBECONFIG=/home/bq/.kube/vis-config
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

    k9s
    kubectl
    krew
    tanka
    jsonnet-bundler
    gnumake
    kubeseal

    vesktop

    (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      })

    zoom-us
    trilium-desktop
    element-desktop
    vscodium
    gimp
  ];

  services.syncthing = {
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
  fonts.fontconfig.enable = true;
  
  # modules
  #nvim.enable = true;
  module.helix.enable = true;

  module.nvf.enable = true;

  module.waybar.enable = true;

  #catppuccin.enable = true;
} 
