{ config, pkgs, lib, ... }:

let
  cfg = config.module.helix;
in {
  options.module.helix.enable = lib.mkEnableOption "Enable custom Helix config";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      settings = {
        theme = "autumn_night_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };

      languages.language = [{
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }];

      themes = {
        autumn_night_transparent = {
          inherits = "autumn_night";
          "ui.background" = {};
        };
      };
    };
  };
}

