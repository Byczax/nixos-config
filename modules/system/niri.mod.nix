{
  config,
  pkgs,
  lib,
  ...
}: let
  enableNiri = config.niri.enable;
in {
  options.niri.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Niri and related packages/services.";
  };

  config = lib.mkIf enableNiri {
    programs.niri = {
      enable = true;
    };
  };
}
