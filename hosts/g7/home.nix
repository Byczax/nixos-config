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

    #FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";

    # inform that we use hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    # QT_QPA_PLATFORM = "xcb";
    QT_SCREEN_SCALE_FACTORS = "1;1";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    TENV_AUTO_INSTALL = "true";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
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
  home.file.".config/electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

  # sync between phone and pc
  services.kdeconnect = {
    enable = true;
    indicator = true;
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
  #        ["temperature" "6500"]
  #        ["gamma 100"]
  #      ];
  #    };
  #    sunset = {
  #      calendar = "*-*-* 19:00:00";
  #      requests = [
  #        ["temperature" "2500"]
  #      ];
  #    };
  #  };
  #};
  services.hyprpolkitagent.enable = true;
  #services.hyprpaper.enable = true;

  # app menu
  programs.wofi = {
    enable = true;
  };

  programs.nh = {
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

    # package = (
    #   pkgs.mpv-unwrapped.wrapper {
    #     mpv = pkgs.mpv-unwrapped.override {
    #       waylandSupport = true;
    #     };
    #   }
    # );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      save-position-on-quit = "yes";
    };
  };

  # other games that are not on steam
  # programs.lutris = {
  #   enable = true;
  #   winePackages = [
  #     pkgs.wineWow64Packages.full
  #   ];
  # };

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

  module.zoom.enable = true;

  module.zsh = {
    enable = true;
    host = "g7";
  };

  module.activitywatch.enable = true;

  #catppuccin.enable = true;
}
