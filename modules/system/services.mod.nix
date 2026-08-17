{pkgs, ...}: {
  services = {
    # autodiscover printers on the LAN
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing.enable = true;
    colord.enable = true;

    tailscale.enable = true;

    thermald.enable = true; # proactively protect CPU from overheating
    upower.enable = true;

    gvfs.enable = true; # mount, trash, etc.
    tumbler.enable = true; # thumbnails
  };

  hardware.sane.enable = true; # SANE scanners

  powerManagement.enable = true;

  # printer to work needs at least this available; hosts add specific drivers.
  services.printing.drivers = with pkgs; [gutenprint];
}
