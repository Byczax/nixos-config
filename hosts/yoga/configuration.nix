# Host-specific config for `yoga`. Shared baseline lives in ../../modules/system/*.mod.nix.
{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  modules.secrets.enable = true;
  modules.steam.enable = true;
  modules.borg.enable = true;

  meta = {
    compositor = "hyprland";
    host.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9pMrB6keoXhaYMfRji4uYAuBzyu0NGPHwTSIMtqidZ";
  };

  # opencode ETHZ LLM api key. Create/edit with: agenix edit secrets/opencode-api-key.age
  age.secrets.opencode-api-key = {
    rekeyFile = ../../secrets/opencode-api-key.age;
    owner = config.meta.mainUser.username;
    mode = "0400";
  };

  # --- host-specific unfree/insecure ---
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "libfprint-2-tod1-goodix" # printer driver for lenovo
        "linux-firmware"
        "zoom"
        "vagrant"
        "symbola"
        "vscode"
        "brgenml1lpr"
        "aseprite"
        "claude-code"
      ];
    allowInsecurePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "electron"
      ];
  };

  # --- boot (host hardware) ---
  boot = {
    loader.timeout = 2;
    kernelParams = [
      "i915.enable_psr=0"
      "mem_sleep_default=s2idle"
      "pci=noaer"
      "acpi_mask_gpe=0x69"
      "acpi_mask_gpe=69"
      "usbcore.autosuspend=-1"
      "pcie_pme=nomsi"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "rtsx_usb"];
    extraModprobeConfig = ''
      options rtsx_usb device_table=0x5812
      options snd-hda-intel dmic_detect=0
    '';
    initrd.systemd.network.wait-online.enable = false;
  };

  security.pam.services.kwallet.enable = true;

  # --- networking (host) ---
  networking = {
    modemmanager.enable = false;
    nftables.enable = true;
    networkmanager.wifi.powersave = false;
    extraHosts = ''
      127.0.0.1 minio
      127.0.0.1 eventmanager-minio
      127.0.0.1 keycloak
    '';
    firewall = rec {
      allowedTCPPorts = [
        465
        993
        3000
        4321
        8000
        config.services.tailscale.port
      ];
      allowedTCPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
        # iperf
        {
          from = 5201;
          to = 5201;
        }
        # Tailscale
        {
          from = 41641;
          to = 41641;
        }
      ];
      allowedUDPPorts = allowedTCPPorts;
      allowedUDPPortRanges = allowedTCPPortRanges;
      trustedInterfaces = ["tailscale0" "virbr0"];
      checkReversePath = "loose";
    };
  };

  hardware = {
    bluetooth.enable = true;
    i2c.enable = true;
    enableRedistributableFirmware = true;
  };

  # --- host-specific services / overrides ---
  services = {
    # extra virtual sink on top of the shared pipewire baseline
    pipewire = {
      jack.enable = true;
      extraConfig.pipewire."91-virtual-sink" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual_output";
              "node.description" = "Virtual Output";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
      };
    };

    tailscale.extraDaemonFlags = ["--no-logs-no-support"];

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    resolved = {
      enable = true;
      settings.Resolve.FallbackDNS = [
        "9.9.9.9"
        "1.1.1.1"
        "2620:fe::fe"
      ];
    };
    envfs.enable = true;
    iperf3.enable = true;
    logind = {
      enable = true;
      settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };

  systemd = {
    # Force tailscaled to use nftables (clean nftables-only systems).
    services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    services.Docker.wantedBy = lib.mkForce ["multi-user.target"];
    services."systemd-backlight@backlight:intel_backlight".enable = false;
    services.NetworkManager-wait-online.enable = false;
    network.wait-online.enable = false;
    services.fprintd = {
      enable = false;
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "simple";
    };
  };

  # extra fonts on top of the shared baseline
  fonts.packages = with pkgs; [
    cardo
    symbola
    quivira
    freefont_ttf
    font-awesome
  ];

  # extra groups on top of the shared user definition
  users = {
    users.${config.meta.mainUser.username}.extraGroups = [
      "i2c"
      "input"
      "scion"
      "wireshark"
    ];
    groups.netdev = {};
    extraGroups.vboxusers.members = [config.meta.mainUser.username];
  };

  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';

  powerManagement.powertop.enable = true;

  programs = {
    vim.enable = true;
    xfconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    wireshark.enable = true;
    virt-manager.enable = true;
  };

  virtualisation = {
    libvirtd.qemu = {
      runAsRoot = false;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [virtiofsd];
    };
    podman = {
      enable = true;
      dockerCompat = false;
    };
  };

  system.stateVersion = "25.05";
}
