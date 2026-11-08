{
  config,
  pkgs,
  lib,
  ...
}: let
  enableSteam = config.modules.steam.enable;
in {
  options.modules.steam.enable = lib.mkOption {
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
      remotePlay.openFirewall = true; # Opens ports for Remote Play
      dedicatedServer.openFirewall = true; # Opens ports for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Opens ports for local transfers
      #remotePlay.openFirewall = true;
      #dedicatedServer.openFirewall = true;
    };
  };
}
