{
  config,
  lib,
  ...
}: {
  options.meta = {
    host.hostPubkey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The SSH host public key used for agenix-rekeying";
    };

    mainUser = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "bq";
        description = "Primary login user for this machine.";
      };
      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.meta.mainUser.username}";
        description = "Home directory of the primary user.";
      };
    };

    compositor = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri"];
      default = "hyprland";
      description = "Wayland compositor this host boots into.";
    };
  };
}
