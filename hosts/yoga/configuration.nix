# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
      #"python3.12-youtube-dl-2021.12.17"

      # Intel Wi-Fi firmware
      "linux-firmware"

      "zoom"
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Amounts of build to store
      };
      timeout = 3; # time before it will start booting most recent build
      efi.canTouchEfiVariables = true; # allow to register boots in boot
    };
    kernelParams = ["i915.force_probe=9a49"];

    # Needed kernel modules for Lenovo systems
    kernelModules = ["acpi_call" "tp_smapi" "i2c-dev" "rts5139" "rts_u" "rts_bio" "rtsx_usb"];
    extraModprobeConfig = ''
      options rts5139 device_table=0x5812
      options rts_u device_table=0x5812
      options rts_bio device_table=0x5812
      options rtsx_usb device_table=0x5812
    '';
  };

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;

    # required by pipewire
    rtkit.enable = true;
    pam.services.kwallet.enable = true;
  };

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
    extraHosts = ''
      127.0.0.1 minio
      127.0.0.1 eventmanager-minio
      127.0.0.1 keycloak
    '';

    # enable ports used by tailscale
    firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  hardware = {
    bluetooth.enable = true;
    i2c.enable = true;
    graphics = {
      enable = true;
      #extraPackages = with pkgs; [
      #  intel-media-sdk
      #];
    };
    enableRedistributableFirmware = true;
  };

  services = {
    connman.wifi.backend = "iwd";
    dbus.enable = true;

    # for multimedia
    pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

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

    tailscale.enable = true; # tailscale, no option for home yet
    thermald.enable = true; # proactively protect CPU overheating
    auto-cpufreq.enable = true; # Show data about CPU
    upower.enable = true;

    tlp = {
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
    # service to autodiscover printers in the same network
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  time.timeZone = "Europe/Zurich"; # timezone, to not be confused

  console.keyMap = "pl"; # enable also polish in console

  # language of the system with some of the formats
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8"];

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
      noto-fonts-color-emoji
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
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "video" "i2c" "input"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    bash
    coreutils
    vim # optional
  ];

  steam.enable = true; # enable steam from module

  programs = {
    # do I need it?
    dconf.enable = true;
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin
        xfce.thunar-volman
      ];
    };
    zsh.enable = true;
    hyprland.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  # control battery, but I think, it does not work with my laptop
  powerManagement.enable = true;

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd.enable = true;
    vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 2048; # Use 2048MiB memory.
        cores = 3;
      };
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
