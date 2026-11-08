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

  modules = {
    secrets.enable = true;
    steam.enable = true;
    borg.enable = true;
  };
  meta = {
    compositor = "hyprland";
    host.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9pMrB6keoXhaYMfRji4uYAuBzyu0NGPHwTSIMtqidZ";
  };

  # opencode ETHZ LLM api key. Create/edit with: agenix edit secrets/opencode-api-key.age
  # Only declared when secrets are available, so a fresh install with
  # modules.secrets.enable = false does not require the rekeyed copy.
  age.secrets = lib.mkIf config.modules.secrets.enable {
    opencode-api-key = {
      rekeyFile = ../../secrets/opencode-api-key.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    };

    litellm-base-url = {
      rekeyFile = ../../secrets/litellm-base-url.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    };
    litellm-api-key = {
      rekeyFile = ../../secrets/litellm-api-key.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    };
    ethz-base-url = {
      rekeyFile = ../../secrets/ethz-base-url.age;
      owner = config.meta.mainUser.username;
      mode = "0400";
    };
  };
  #
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     mozc = prev.mozc.overrideAttrs (oldAttrs: {
  #       postPatch =
  #         (oldAttrs.postPatch or "")
  #         + ''
  #           find src/gui -name "*.ui" -exec sed -i 's/::mozc::gui::/mozc::gui::/g' {} +
  #         '';
  #     });
  #   })
  # ];
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
      "usbcore.autosuspend=-1"
      "pcie_pme=nomsi"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "rtsx_usb"];
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
    graphics = {
      enable = true;
      extraPackages = [pkgs.intel-media-driver];
    };
  };

  # --- host-specific services / overrides ---
  services = {
    # extra virtual sink on top of the shared pipewire baseline
    pipewire = {
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
        HandleLidSwitchDocked = "ignore"; # the error with hyprlock still persist
      };
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="i2c", KERNEL=="i2c-MSFT0001:00", ATTR{power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="serio", KERNEL=="serio0", ATTR{power/wakeup}="disabled"
    '';
  };

  systemd = {
    # Force tailscaled to use nftables (clean nftables-only systems).
    services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    services.docker.wantedBy = lib.mkForce ["multi-user.target"];
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
    # symbola
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
