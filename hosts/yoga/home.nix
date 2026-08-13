{
  config,
  osConfig, # NixOS config, to reach decrypted agenix secret paths
  pkgs,
  inputs,
  lib,
  compositor,
  ...
}: {
  imports = [
    ./programs.nix
  ];

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "bq";
    homeDirectory = "/home/bq";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "26.05";
    sessionVariables = lib.mkMerge [
      {
        # info where to save config files
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
        EDITOR = "nvim";

        # inform apps that we use wayland
        NIXOS_OZONE_WL = "1";
        OZONE_PLATFORM = "wayland";

        # suggests electron apps to use the wayland backend
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";

        XDG_SESSION_TYPE = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        QT_SCREEN_SCALE_FACTORS = "1;1";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        TENV_AUTO_INSTALL = "true";
        WAYLAND_DISPLAY = "wayland-1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      }

      (lib.mkIf (compositor == "hyprland") {
        AAA = "1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        QT_QPA_PLATFORM = "wayland";
      })

      (lib.mkIf (compositor == "niri") {
        BBB = "1";
        XDG_CURRENT_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
      })
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
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
    gtk4.theme = null;
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

  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
    git = {
      enable = true;
    };
    lazygit = {
      enable = true;
      enableZshIntegration = true;
    };
    # gcc.enable = true;
    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Fira Code:size=11";
          # include = "~/.config/foot/theme-active.ini";
          #dpi-aware = "yes";
        };
        cursor = {
          style = "beam";
          blink = "no";
        };
        url = {
          osc8-underline = "always";
          launch = "xdg-open \${url}";
        };
      };
    };
    hyprlock.enable = true;

    # app menu
    wofi = {
      enable = true;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bq/nixos-config";
    };
    zathura = {
      enable = true;
      extraConfig = "set selection-clipboard clipboard";
    };
    # media player
    mpv = {
      enable = true;
      # override = {
      #   waylandSupport = true;
      # };

      #
      # package = pkgs.mpv-unwrapped.wrapper {
      #   mpv = pkgs.mpv-unwrapped.override {
      #     waylandSupport = true;
      #   };
      # };
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        save-position-on-quit = "yes";
        gpu-api = "auto";
        gpu-context = "wayland";
        tone-mapping = "clip";
      };
    };
    # other games that are not on steam
    # lutris = {
    #   enable = true;
    #   winePackages = [
    #     pkgs.wineWow64Packages.full
    #   ];
    # };
    command-not-found.enable = false;
    nix-index.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
    satty = {
      enable = true;
      settings = {
        general = {
          fullscreen = true;
          corner-roundness = 12;
          initial-tool = "brush";
          output-filename = "/tmp/test-%Y-%m-%d_%H:%M:%S.png";
        };
        color-palette = {
          palette = ["#00ffff" "#a52a2a" "#dc143c" "#ff1493" "#ffd700" "#008000"];
        };
      };
    };

    borgmatic = {
      enable = true;
      backups = {
        synology = {
          consistency = {
            checks = [
              {
                name = "repository";
                frequency = "2 weeks";
              }
              {
                name = "archives";
                frequency = "4 weeks";
              }
              {
                name = "data";
                frequency = "6 weeks";
              }
              {
                name = "extract";
                frequency = "6 weeks";
              }
            ];
          };
          location = {
            repositories = [(import ./private.nix).borgRepo];
            extraConfig = {
              remote_path = "/usr/local/bin/borg";
              # Passphrase read from decrypted agenix secret at runtime
              encryption_passcommand = "cat ${osConfig.age.secrets.borg-passphrase.path}";
            };
            patterns = [
              "R /home/bq"
              "- /home/bq/.cache"
              "- /home/bq/.config"
              "- /home/bq/.local"
              "- /home/bq/Media"
              "- /home/bq/.java"
            ];
          };
          retention = {
            keepDaily = 7; # last week
            keepWeekly = 4; # last month
            keepMonthly = 12; # last year
            keepYearly = 3; # long-term
          };
        };
      };
    };
    nix-init = {
      enable = true;
    };
    bat.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 10000;
      mouse = true;
      newSession = true;
      sensibleOnTop = true;
      baseIndex = 1;
      shell = "${pkgs.zsh}/bin/zsh";
      tmuxp.enable = true;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        tokyo-night-tmux
        yank
      ];
    };

    alacritty.enable = true;
    fuzzel.enable = true;
    # swaylock.enable = true;

    distrobox = {
      enable = true;
      enableSystemdUnit = true;
      settings = {
        container_manager = "podman";
        container_always_pull = "1";
        container_generate_entry = 1;
      };
      containers = {
        thesis = {
          image = "ubuntu:latest";
          entry = true;
          additional_packages = [
            "zsh"
            "git"
            "curl"
            "build-essential"
            "python3"
            "python3-pip"
            "software-properties-common"
            "golang"
            "nvim"
            "vim"
          ];
          environment = [
            "SHELL=zsh"
          ];
          # init_hooks = [
          #   "sudo apt update"
          #   "sudo apt install -y ca-certificates curl gnupg"
          #
          #   "sudo install -m 0755 -d /etc/apt/keyrings"
          #
          #   "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
          #
          #   "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
          #
          #   "sudo apt update"
          #   "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
          #
          #   "sudo service docker start"
          #   "sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch"
          #   "sudo apt update"
          #   "sudo apt install -y fastfetch"
          # ];
        };
      };
    };
    feh = {
      enable = true;
    };
    go = {
      enable = true;
    };
    k9s = {
      enable = true;
    };
    vesktop = {
      enable = true;
    };
    fastfetch = {
      enable = true;
    };
    anki = {
      enable = true;
      theme = "dark";
      minimalistMode = true;
    };
    vscode = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  home.file = {
    # terminal
    ".config/electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform-hint=auto
    '';

    # ".config/foot/themes/local.ini".text = ''
    #   [colors-dark]
    #   foreground=c0caf5
    #   background=2e3440
    #   regular0=3b4252
    #   regular1=bf616a
    #   regular2=a3be8c
    #   regular3=ebcb8b
    #   regular4=81a1c1
    #   regular5=b48ead
    #   regular6=88c0d0
    #   regular7=e5e9f0
    # '';
    #
    # ".config/foot/themes/local2.ini".text = ''
    #   [colors-dark]
    #   foreground=c0caf5
    #   background=1a1b26
    #   regular1=f7768e
    #   regular2=9ece6a
    #   regular3=e0af68
    #   regular4=7aa2f7
    #   regular5=bb9af7
    #   regular6=7dcfff
    #   regular7=a9b1d6
    # '';
    #
    # ".config/foot/themes/server1.ini".text = ''
    #   [colors-dark]
    #   background=3b1020
    #   foreground=f5c2e7
    # '';
    #
    # ".config/foot/themes/server2.ini".text = ''
    #   [colors-dark]
    #   background=0b1d26
    #   foreground=89dceb
    # '';
  };

  services = {
    # sync between phone and pc
    kdeconnect = {
      enable = true;
      indicator = true;
    };

    # swayidle = {
    #   enable = true;
    #
    #   timeouts = [
    #     {
    #       timeout = 300;
    #       command = "${pkgs.hyprlock}/bin/hyprlock";
    #     }
    #     {
    #       timeout = 600;
    #       command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
    #       resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
    #     }
    #   ];
    #
    #   events = [
    #     {
    #       event = "before-sleep";
    #       command = "${pkgs.hyprlock}/bin/hyprlock";
    #     }
    #   ];
    # };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 300;
            # on-timeout = "hyprlock";
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
            #on-timeout = "niri msg action power-off-monitors";
            #on-resume = "niri msg action power-on-monitors";
          }
          {
            timeout = 900; # 15 minutes
            on-timeout = "systemctl suspend"; # Explicitly suspend the machine
          }
        ];
      };
    };

    wlsunset = {
      enable = true;
      latitude = 47.41;
      longitude = 8.65;
      temperature = {
        day = 4200;
        night = 2000;
      };
    };

    syncthing = {
      enable = false;
    };
    hyprpolkitagent.enable = true;
    # notifications
    mako = {
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
    # flameshot = {
    #   enable = true;
    #   # package = pkgs.flameshot.override {
    #   #   enableWlrSupport = true;
    #   # };
    #   # settings = {
    #   #   General = {
    #   #     useGrimAdapter = true;
    #   #     disabledGrimWarning = true;
    #   #   };
    #   # };
    # };

    flameshot = {
      enable = true;
      # Override package to ensure WLR/Wayland support is compiled in
      package = pkgs.flameshot.override {enableWlrSupport = true;};

      settings = {
        General = {
          # Save Path
          # savePath = "/home/user/Screenshots";
          # Tray
          # disabledTrayIcon = true;
          # Greeting message
          # showStartupLaunchMessage = false;

          # Default file extension for screenshots (.png by default)
          saveAsFileExtension = ".png";

          # Desktop notifications
          showDesktopNotification = true;

          # Whether to show the info panel in the center in GUI mode
          showHelp = true;

          # Whether to show the left side button in GUI mode
          showSidePanelButton = true;

          # Color Customization
          uiColor = "#740096";
          contrastUiColor = "#270032";
          drawColor = "#ff0000";
        };
      };
    };

    borgmatic = {
      enable = true;
      frequency = "daily";
    };

    cliphist = {
      enable = true;

      # A Wayland session
      # systemdTargets = ["config.wayland.systemd.target"];
      # Hyprland session
      systemdTargets = ["hyprland-session.target"];

      # Sway Target
      # if using make sure that:
      # "wayland.windowManager.sway.systemd.enable = true;" is set
      #systemdTargets = ["sway-session.target"];

      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
      allowImages = true;
    };
    arrpc.enable = true;
  };

  xdg.configFile."niri/config.kdl".source = ../../modules/home/niri/niri-config.kdl;
  #xdg.configFile."flameshot.ini".force = true;
  # do I need it?
  #fonts.fontconfig.enable = true;

  # modules
  #nvim.enable = true;
  module = {
    hyprland.enable = true;
    helix.enable = true;
    nvf.enable = true;
    waybar.enable = true;
    zen.enable = true;
    zoom.enable = true;
    thunderbird.enable = true;
    firefox.enable = true;
    zsh = {
      enable = true;
      host = "yoga";
    };
    activitywatch.enable = true;
    kanshi.enable = true;
    jelly-mpv.enable = true;
    opencode.enable = true;
    #catppuccin.enable = true;
  };

  i18n.inputMethod = {
    #  # Available since NixOS 24.11
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      #ignoreUserConfig = true; # Use settings below, ignore user config
      addons = with pkgs; [
        fcitx5-mozc # Japanese input method
      ];

      #settings = {
      #  inputMethod = {
      #    GroupOrder."0" = "Default";
      #    "Groups/0" = {
      #      Name = "Default";
      #      "Default Layout" = "pl"; # Polish keyboard
      #      DefaultIM = "mozc"; # Default input method
      #    };
      #    "Groups/0/Items/0".Name = "keyboard-pl";
      #    #"Groups/0/Items/0".Layout = "";
      #    "Groups/0/Items/1".Name = "mozc";
      #    #"Groups/0/Items/1".Layout = "";
      #
      #    #    #"Groups/0/Items/2".Name = "keyboard-ru";
      #    #    #"Groups/0/Items/2".Layout = "ru";
      #    #    #"GroupOrder" = {
      #    #    #  "0" = "Default";
      #    #    #};
      #  };
      #};
      #    settings = {
      #      inputMethod = {
      #        GroupOrder."0" = "Default";
      #        "Groups/0" = {
      #          Name = "Default";
      #          "Default Layout" = "keyboard-pl";
      #          DefaultIM = "mozc";
      #        };
      #        "Groups/0/Items/0".Name = "keyboard-pl";
      #        "Groups/0/Items/1".Name = "mozc";
      #      };
      #    };
    };
  };
}
