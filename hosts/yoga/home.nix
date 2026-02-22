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
    sessionVariables = {
      # info where to save config files
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      EDITOR = "nvim";

      # inform apps that we use wayland
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";

      # suggests electron apps to use the wayland backend
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      #FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

      # inform that we use hyprland
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "xcb";
      QT_SCREEN_SCALE_FACTORS = "1;1";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      TENV_AUTO_INSTALL = "true";
    };
    # make sure that user have polish layout
    #keyboard = {
    #  layout = "pl,us";
    #  options = [
    #    "grp:alt_shift_toggle"
    #  ];
    #};
  };
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.

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

      #
      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      };
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
            repositories = ["ssh://maciej_byczko@byczkosynology/var/services/homes/maciej_byczko/Backup/nixos"];
            extraConfig = {
              remote_path = "/usr/local/bin/borg";
              encryption_passphrase = "repokey";
            };
            patterns = [
              "R /home/bq"
              "- /home/bq/.cache"
              "- /home/bq/.config"
              "- /home/bq/.local"
              "- /home/bq/Media"
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
    #swayidle.enable = true;
    syncthing = {
      enable = false;
    };
    hypridle = {
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
    flameshot = {
      enable = true;
      # package = pkgs.flameshot.override {
      #   enableWlrSupport = true;
      # };
      settings = {
        General = {
          useGrimAdapter = true;
          disabledGrimWarning = true;
        };
      };
    };

    borgmatic = {
      enable = true;
      frequency = "daily";
    };
  };

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
