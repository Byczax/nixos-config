{lib, ...}: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10; # number of builds to keep
    };
    timeout = lib.mkDefault 3; # seconds before booting newest build
    efi.canTouchEfiVariables = true;
  };
}
