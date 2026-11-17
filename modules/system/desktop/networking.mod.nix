{lib, ...}: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = lib.mkDefault true;
      };
    };
    wireless.iwd.enable = true;
  };
}
