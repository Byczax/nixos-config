{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.activitywatch;
in {
  options.module.activitywatch.enable = lib.mkEnableOption "Enable custom activitywatch config";

  config = lib.mkIf cfg.enable {
    services.activitywatch = {
      enable = true;
      package = pkgs.aw-server-rust;
      settings = {
        port = 5600;
      };
      watchers = {
        aw-awatcher = {
          package = pkgs.awatcher;
          executable = "awatcher";
          settings = {
            idle-timeout-seconds = 180;
            poll-time-idle-seconds = 10;
            poll-time-window-seconds = 5;
          };
        };
      };
    };
  };
}
