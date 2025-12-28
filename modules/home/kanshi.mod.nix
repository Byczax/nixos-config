{
  config,
  lib,
  ...
}: let
  cfg = config.module.kanshi;
in {
  options.module.kanshi.enable = lib.mkEnableOption "Enable custom kanshi config";

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                criteria = "eDP-1";
                position = "1920,120";
                mode = "1920x1080@60.05Hz";
                status = "enable";
              }
              {
                criteria = "DP-5";
                position = "5760,0";
                mode = "1920x1080@60.0Hz";
                transform = "90";
                status = "enable";
              }
              {
                criteria = "DP-6";
                position = "0,0";
                mode = "1920x1200@59.95Hz";
                status = "enable";
              }
              {
                criteria = "DP-7";
                position = "3840,120";
                mode = "1920x1080@60.0Hz";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office2";
            outputs = [
              {
                criteria = "eDP-1";
                position = "1920,120";
                mode = "1920x1080@60.05Hz";
                status = "enable";
              }
              {
                criteria = "DP-8";
                position = "5760,0";
                mode = "1920x1080@60.0Hz";
                transform = "90";
                status = "enable";
              }
              {
                criteria = "DP-9";
                position = "0,0";
                mode = "1920x1200@59.95Hz";
                status = "enable";
              }
              {
                criteria = "DP-10";
                position = "3840,120";
                mode = "1920x1080@60.0Hz";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office3";
            outputs = [
              {
                criteria = "eDP-1";
                position = "1920,0";
                mode = "1920x1080@60.05Hz";
                status = "enable";
              }
              {
                criteria = "Dell Inc. DELL U2913WM 5YD8C2C8187L";
                position = "3840,0";
                mode = "2560x1080@60.0Hz";
                status = "enable";
              }
            ];
          };
        }
      ];
    };
  };
}
