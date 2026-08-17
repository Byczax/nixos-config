{
  security = {
    # sudo written in Rust
    sudo.enable = false;
    sudo-rs.enable = true;

    # required by pipewire
    rtkit.enable = true;
  };

  services = {
    dbus.enable = true;
    gnome.gnome-keyring.enable = true; # secret service
    pcscd.enable = true; # smartcard / yubikey
  };
}
