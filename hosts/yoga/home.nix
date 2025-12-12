{
  config,
  pkgs,
  inputs,
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
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.

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

  programs = {
    foot = {
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
    hyprlock.enable = true;
    zsh = {
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
      history.ignorePatterns = ["rm *" "pkill *" "cp *" "la*" ".." "l*" "la*" "./rsync_local.sh" "update" "git *" "nvim"];
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
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };

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

      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      };
      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        save-position-on-quit = "yes";
      };
    };
    # other games that are not on steam
    lutris = {
      enable = true;
      winePackages = [
        pkgs.wineWow64Packages.full
      ];
    };
    command-not-found.enable = false;
    nix-index.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # terminal
  home.file.".config/electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';
  services = {
    gnome-keyring.enable = true;
    # sync between phone and pc
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    # local telemetry on yourslef
    activitywatch = {
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
            TimeoutStartSec = 60;
            log_level = "debug";
            #testing_backend = "wayland";
            backend = "libinput";
            Service = {
              "Environment=WAYLAND_DISPLAY" = "wayland-1";
              "Environment=XDG_RUNTIME_DIR" = "/run/user/1000";
            };
          };
        };
        aw-awatcher = {
          package = pkgs.awatcher;
          executable = "awatcher";
          settings = {
            idle-timeout-seconds = 180;
            poll-time-idle-seconds = 10;
            poll-time-window-seconds = 5;
          };
        };
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

    kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                criteria = "eDP-1";
                position = "1920,120";
                mode = "1920x1080@60.05Hz";
                status = "enable";
              }
              {
                criteria = "DP-5";
                position = "5760,0";
                mode = "1920x1080@60.0Hz";
                transform = "90";
                status = "enable";
              }
              {
                criteria = "DP-6";
                position = "0,0";
                mode = "1920x1200@59.95Hz";
                status = "enable";
              }
              {
                criteria = "DP-7";
                position = "3840,120";
                mode = "1920x1080@60.0Hz";
                status = "enable";
              }
            ];
          };
        }
      ];
    };
  };

  #systemd.user.services.activitywatch-watcher-aw-watcher-afk = {
  #  Service = {
  #    ExecStartPre = "${pkgs.bash}/bin/sh -c \"while [ -z $DISPLAY ]; do ${pkgs.coreutils}/bin/sleep 5; done\"";
  #  };
  #};
  #
  #systemd.user.services.activitywatch-watcher-aw-watcher-window = {
  #  Service = {
  #    ExecStartPre = "${pkgs.bash}/bin/sh -c \"while [ -z $DISPLAY ]; do ${pkgs.coreutils}/bin/sleep 5; done\"";
  #  };
  #};

  # make sure that user have polish layout
  home.keyboard = {
    layout = "pl";
  };

  services.swayidle.enable = true;
  services.syncthing = {
    enable = true;
  };
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
  services.hyprpolkitagent.enable = true;
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
  # do I need it?
  fonts.fontconfig.enable = true;

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
    #catppuccin.enable = true;
  };
}
