{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: {
  modules.apps = {
    latexPackages = ps:
      with ps; [
        scheme-basic
        latex
        geometry
        xcolor
        amsmath
        fontspec
        hyperref
        moderncv
        polski
        latexmk
        enumitem
        pgf
        titlesec
      ];

    jq = false;
    qtwayland = false;
    grim = false;
    slurp = false;
    gopls = false;
    wakatime-cli = false;
    claude-code = false;
    ansible = false;
    tenv = false;
    jellyfin-media-player = false;
    memento = false;
    openconnect = false;
    yubikey-manager = false;
    yubioath-flutter = false;
    age-plugin-yubikey = false;
    git-agecrypt = false;
    bibata-cursors = false;
    wdisplays = false;
    rpi-imager = false;
    qgis = false;
  };

  programs = {
    git.enable = true;
    lazygit.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    tmux.enable = true;
    go.enable = true;
    feh.enable = true;
    fastfetch.enable = true;
    vesktop.enable = true;
    k9s.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = osConfig.meta.mainUser.username;
  home.homeDirectory = osConfig.meta.mainUser.homeDirectory;

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

  # terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code:size=11";
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

  services = {
    wlsunset = {
      enable = true;
      latitude = 47.41;
      longitude = 8.65;
      temperature = {
        day = 4200;
        night = 2000;
      };
    };
    # Make sure if you enable it, to configure the fans
    # dell-bios-fan-control.enable = true;
  };

  # make sure that user have polish layout
  home.keyboard = {
    layout = "pl";
  };

  services.swayidle.enable = true;

  # hyprland stack
  modules.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on; pidof hyprlock || hyprlock";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
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
    configPath = "${config.xdg.configHome}/mozilla/firefox";

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
  modules.helix.enable = true;

  modules.nvf.enable = true;

  modules.waybar.enable = true;

  modules.zoom.enable = true;

  modules.zsh = {
    enable = true;
  };

  modules.activitywatch.enable = true;

  #catppuccin.enable = true;
}
