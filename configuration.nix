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
      ];
    };
  };


  services = {
    pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
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

  # Enable CUPS to print documents.
  services.printing.enable = true;


  users.users.bq = {
    isNormalUser = true;
    description = "bq";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  }; 

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  powerManagement.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell=pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  services.borgbackup.jobs."borgbase" = {
    paths = "/home/bq";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/bq/.ssh/synology";
    repo = "ssh://maciej_byczko@byczkosynology:41024/volume1/homes/maciej_byczko/Backup/nixos";
    compression = "auto,zstd";
    startAt = "daily";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # networking.firewall = rec {
  # allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  # allowedUDPPortRanges = allowedTCPPortRanges;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
