{
  config,
  pkgs,
  lib,
  ...
}: let
  enableSteam = config.steam.enable;
in {
  options.steam.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Steam and related packages/services.";
  };

  config = lib.mkIf enableSteam {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      #remotePlay.openFirewall = true;
      #dedicatedServer.openFirewall = true;
    };
  };
}
