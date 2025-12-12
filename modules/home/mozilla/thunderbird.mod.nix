{
  config,
  lib,
  ...
}: let
  cfg = config.module.thunderbird;
in {
  options.module.thunderbird.enable = lib.mkEnableOption "Enable custom thunderbird browser config";

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
