{
  config,
  lib,
  ...
}: let
  cfg = config.modules.thunderbird;
in {
  options.modules.thunderbird.enable = lib.mkEnableOption "Enable custom thunderbird browser config";

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
