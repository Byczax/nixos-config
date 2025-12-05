{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./programs.nix
  ];
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
    EDITOR = "nvim";

    # inform apps that we use wayland
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM = "wayland";

    # suggests electron apps to use the wayland backend
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    # inform that we use hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
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

  # terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Fira Code:size=11";
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
          poll_time = 1;
          timeout = 60;
          TimeoutStartSec = 120;
          #log_level = "debug";
          #testing_backend = "wayland";
          Service = {
            "Environment=WAYLAND_DISPLAY" = "wayland-1";
            "Environment=XDG_RUNTIME_DIR" = "/run/user/1000";
          };
        };
      };
      #aw-watcher-window = {
      #  package = pkgs.aw-watcher-window;
      #  settings = {
      #    poll_time = 1;
      #    exclude_title = false;
      #  };
      #};

      #aw-watcher-window-wayland = {
      #  package = pkgs.aw-watcher-window-wayland;
      #  settings = {
      #    poll_time = 1;
      #    exclude_title = false;
      #  };
      #};
      aw-watcher-window-hyprland = {
        package = inputs.aw-watcher-hyprland.packages.${pkgs.stdenv.system}.aw-watcher-window-hyprland;
        settings = {
          poll_time = 1;
          exclude_title = false;
          timeout = 60;
          TimeoutStartSec = 120;
          Service = {
            "Environment=WAYLAND_DISPLAY" = "wayland-1";
            "Environment=XDG_RUNTIME_DIR" = "/run/user/1000";
          };
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
  #services.hyprsunset = {
  #  enable = true;
  #  transitions = {
  #    sunrise = {
  #      calendar = "*-*-* 06:00:00";
  #      requests = [
  #        [ "temperature" "6500" ]
  #        [ "gamma 100" ]
  #      ];
  #    };
  #    sunset = {
  #      calendar = "*-*-* 19:00:00";
  #      requests = [
  #        [ "temperature" "2500" ]
  #      ];
  #    };
  #  };
  #};
  services.hyprpolkitagent.enable = true;
  #services.hyprpaper.enable = true;

  # more zsh stuff
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "nh os switch /home/bq/nixos-config -H yoga --ask";
      test_vm = "sudo nixos-rebuild build-vm --flake /home/bq/nixos-config/#default";
      calc = "qalc";
      bat_protect_on = "sudo echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
      bat_protect_off = "sudo echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
    };
    history.size = 100000;
    history.ignorePatterns = ["rm *" "pkill *" "cp *" "la*" ".." "l*" "la*" "./rsync_local.sh" "update" "git *"];
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
    initContent = ''
      bindkey "^R" history-incremental-search-backward;
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
      export KUBECONFIG=/home/bq/.kube/vis-config
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/bq/nixos-config";
  };

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
      save-position-on-quit = "yes";
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
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  # do I need it?
  fonts.fontconfig.enable = true;

  # modules
  #nvim.enable = true;
  module.helix.enable = true;

  module.nvf.enable = true;

  module.waybar.enable = true;

  module.zen.enable = true;

  module.zoom.enable = true;

  #catppuccin.enable = true;
}
