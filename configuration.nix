# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings ={ 
      experimental-features = [ 
        "nix-command" 
        "flakes" 
      ];
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "libfprint-2-tod1-goodix"
  ];
  
  boot = {
    loader = {
      systemd-boot = {
        enable = true;      
        configurationLimit = 10;
      };
      timeout = 3;
      efi.canTouchEfiVariables = true;
    };
  };

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;

    rtkit.enable = true;
  };
  #zramSwap.enable = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
  hardware.bluetooth.enable = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
  services.dbus.enable = true;


  services = {
    pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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

    xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    tailscale.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;

  };

  time.timeZone = "Europe/Zurich";

  console.keyMap = "pl"; # maybe pl2
  #i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;
  hardware.sane.enable = true; # enables support for SANE scanners
  services.colord.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  programs.dconf = {
    enable = true;
  };

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;


  users.users.bq = {
    isNormalUser = true;
    description = "bq";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  }; 
  steam.enable = true;

  powerManagement.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell=pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  
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
  networking.firewall = rec {
  allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  allowedUDPPortRanges = allowedTCPPortRanges;
};

  # Needed kernel modules for Lenovo systems
  boot.kernelModules = [ "acpi_call" "tp_smapi" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
