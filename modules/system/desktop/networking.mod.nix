{lib, ...}: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = lib.mkDefault true;
      };
    };
    wireless.iwd = {
      enable = true;
      settings = {
        Network.EnableIPv6 = true;
        Settings.AutoConnect = true;
      };
    };
  };

  services.connman.wifi.backend = "iwd";
}
