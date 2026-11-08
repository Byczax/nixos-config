# Host-specific config for `g7`. Shared baseline lives in ../../modules/system/*.mod.nix.
{
  config,
  lib,
  pkgs,
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
    # TODO: set g7's real host key for agenix-rekey (needed before rekeying secrets,
    # e.g. the borg passphrase). Get it with:
    #   cat /etc/ssh/ssh_host_ed25519_key.pub
    host.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMo9pgMfM4Zi40Wmru1ByyREmbqLej8IUsdlQNxWfgK";
  };

  # host-only overlay: openldap tests fail on this box
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "libfprint-2-tod1-goodix" # printer driver for lenovo
        "python3.12-youtube-dl-2021.12.17"
        "linux-firmware"
        "zoom"
        "nvidia-x11"
        "nvidia-settings"
        "claude-code"
      ];
    allowInsecurePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "electron"
      ];
  };

  boot = {
    kernelParams = [
      "alienware-wmi"
      "i2c-dev"
      "acpi_osi=Linux-Dell-Video"
      "i915.enable_guc=2"
      "i915.enable_psr=0"
      "i915.enable_fbc=0"
      "i915.fastboot=0"
      "i915.enable_dc=0"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
    ];
    kernelModules = ["acpi_call" "tp_smapi" "i2c-dev" "alienware-wmi"];
    extraModprobeConfig = ''
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
      options i915 reset=1
      options i8k force=1
    '';
  };

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # --- host hardware: nvidia + alienware ---
  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };
  services.hardware.dell-bios-fan-control.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="187c", ATTRS{idProduct}=="0550", MODE="0666"
  '';

  services.xserver = {
    videoDrivers = ["nvidia"];
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        offload.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      powerManagement.enable = false;
      nvidiaSettings = false;
    };
    enableRedistributableFirmware = true;
  };

  programs.dconf.enable = true;

  # fingerprint reader
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;

  # Lid behaviour: suspend on battery, lock on charger, lock when docked
  # (external monitors keep working, no suspend so no wake-with-new-monitors
  # crash path). Matches yoga.
  services.logind = {
    enable = true;
    settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "lock";
    };
  };

  # --- battery / thermal (this host uses both tlp and auto-cpufreq) ---
  services.auto-cpufreq.enable = true;
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
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  system.stateVersion = "25.05";
}
