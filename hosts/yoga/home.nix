{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.orden.homeManagerModules.default ./distrobox.nix];

  home = {
    stateVersion = "26.05";
    sessionVariables = {
      WAYLAND_DISPLAY = "wayland-1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };
  };
  programs.orden = {
    enable = true;
    package = inputs.orden.packages.${pkgs.stdenv.hostPlatform.system}.orden-unstable.overrideAttrs (oldAttrs: {
      pnpmDepsHash = "sha256-3OH5zSUgmuLgwXRe8vXdx7E7T4n5SVMdQvmNDEP2yL8=";
    });
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
      # package = null;
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  programs = {
    mpv.config = {
      gpu-api = "auto";
      gpu-context = "wayland";
      tone-mapping = "clip";
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

    nix-init = {
      enable = true;
    };
    bat.enable = true;

    alacritty.enable = true;
    fuzzel.enable = true;
    # swaylock.enable = true;
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

    syncthing = {
      enable = false;
    };
    arrpc.enable = true;
  };

  # niri config now deployed by modules/home/niri.mod.nix (only when
  # meta.compositor = "niri"). Left here intentionally blank.
  #xdg.configFile."flameshot.ini".force = true;
  # do I need it?
  #fonts.fontconfig.enable = true;

  modules = {
    desktop.enable = true;
    cli.enable = true;
    # hyprland.enable defaults from meta.compositor (on for hyprland, off for niri)
    helix.enable = true;
    nvf.enable = true;
    waybar.enable = true;
    zen.enable = true;
    thunderbird.enable = true;
    firefox.enable = true;
    zsh.enable = true;
    activitywatch.enable = true;
    kanshi.enable = true;
    jelly-mpv.enable = true;
    opencode.enable = true;
    claudeCode.enable = true;
    deepseek-harness.enable = false;
    #catppuccin.enable = true;

    apps = {
      bundles = ["cli" "dev" "infra" "office" "creative" "media" "network" "security" "desktop" "hardware" "comms" "games"];
      latex = true;
    };
  };

  home.packages = with pkgs; [
    jq
    qt5.qtwayland
    grim
    slurp
    gopls
    wakatime-cli
    ansible
    tenv
    jellyfin-media-player
    memento
    openconnect
    yubikey-manager
    yubioath-flutter
    bibata-cursors
    wdisplays
    rpi-imager
    qgis
  ];
}
