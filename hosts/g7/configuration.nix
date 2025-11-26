# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/steam.nix # steam config, avaliable only systemwide
  ];

  # Enable flakes, because they are amazing
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      #auto-optimise-store = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
    config.common.default = ["hyprland"];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Those are required to install steam and games
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"

      # printer driver for lenovo
      "libfprint-2-tod1-goodix"
      "python3.12-youtube-dl-2021.12.17"

      # Intel Wi-Fi firmware
      "linux-firmware"

      "zoom"
      "nvidia-x11"
      "nvidia-settings"
    ];

  # boot specifications
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Amounts of build to store
      };
      timeout = 3; # time before it will start booting most recent build
      efi.canTouchEfiVariables = true; # allow to register boots in boot
    };
    kernelParams = ["alienware-wmi" "i2c-dev" "acpi_osi=Linux-Dell-Video" "i915.enable_guc=2"];
  };

  security = {
    # use sudo written in Rust
    sudo.enable = false;
    sudo-rs.enable = true;

    # required by pipewire
    rtkit.enable = true;
  };

  # enable internet and wifi support
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };
    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };
  services.connman.wifi.backend = "iwd";

  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="187c", ATTRS{idProduct}=="0550", MODE="0666"
  '';

  services.xserver = {
    videoDrivers = ["nvidia"];
    #displayManager.startx.enable = false;
    #windowManager.default = "hyprland";
  };
  # bluetooth, what else
  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-sdk
      ];
    };

    nvidia = {
      open = true;
      modesetting.enable = true;
      prime = {
        #enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    enableRedistributableFirmware = true;
  };

  services.dbus.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services = {
    # for multimedia
    pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # login screen with Hyprland as window manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd 'systemd-cat -t Hyprland Hyprland'";
          user = "bq";
        };
      };
    };

    # enable polish as keyboard layout
    xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    # tailscale, no option for home yet
    tailscale.enable = true;

    # proactively protect CPU overheating
    thermald.enable = true;

    # Show data about CPU
    auto-cpufreq.enable = true;

    upower.enable = true;
  };

  # timezone, to not be confused
  time.timeZone = "Europe/Zurich";

  # enable also polish in console
  console.keyMap = "pl"; # maybe pl2

  # language of the system with some of the formats
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8"];

  # service to autodiscover printers in the same network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # do I need it?
  programs.dconf.enable = true;

  # Required for printer to work
  services.printing.enable = true;
  hardware.sane.enable = true; # enables support for SANE scanners
  services.colord.enable = true;

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  fonts = {
    enableDefaultPackages = true;
    #fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };
  # system user
  users.users.bq = {
    isNormalUser = true;
    description = "bq";
    initialPassword = "changeme";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    bash
    coreutils
    vim # optional
  ];
  programs.hyprland.enable = true;

  # eanble steam from module
  steam.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
    ];
  };
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # use zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  # control battery, but I think, it does not work with my laptop
  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  # enable ports used by tailscale
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # Needed kernel modules for Lenovo systems
  boot.kernelModules = ["acpi_call" "tp_smapi" "i2c-dev"];
  virtualisation.docker = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
