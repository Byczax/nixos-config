{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.module.waybar;
in {
  options.module.waybar.enable = lib.mkEnableOption "Enable custom waybar config";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ./waybar_style.css;
      settings = [
        {
          "layer" = "top";
          "position" = "top";
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [];
          modules-right = [
            "tray"
            "network"
            "wireplumber"
            "bluetooth"
            "cpu"
            "memory"
            "custom/temperature"
            "backlight"
            "battery"
            "clock#date"
            "clock#time"
          ];
          "network" = {
            "format-wifi" = "  {essid} ({signalStrength}%)";
            "format-ethernet" = "{ifname}";
            "format-disconnected" = " ";
            "max-length" = 50;
            #"on-click" = "exec alacritty -e nmtui";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          };

          "bluetooth" = {
            "format" = " {status}";
            "format-disabled" = ""; #// an empty format will hide the module
            "format-connected" = " {num_connections} conn";
            "tooltip-format" = "{controller_alias}\t{controller_address}";
            "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          };

          "cpu" = {
            "format" = " {usage:02}%";
            "tooltip" = false;
            "interval" = 1;
            "on-click" = "exec alacritty -e btop";
          };
          "memory" = {
            "format" = "  {used:0.1f}/{total:0.1f}G ";
          };
          "custom/temperature" = {
            "exec" = "sensors | awk '/^Package id 0:/ {print int($4)}'";
            "format" = " {}°C ";
            "interval" = 5;
          };
          "backlight" = {
            "format" = "{icon} {percent}%";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "battery" = {
            "format" = "{icon} {capacity:02}%";
            "format-icons" = {
              "default" = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              "charging" = [
                "󰢜"
                "󰂇"
                "󰢝"
                "󰢞"
                "󰂅"
              ];
            };
            "states" = {
              "warning" = 20;
              "critical" = 10;
            };
          };

          "clock#date" = {
            "format" = "{:%d.%m}";
          };
          "clock#time" = {
            "format" = "{:%H:%M:%OS}";
            "interval" = 1;
          };
          "wireplumber" = {
            "format" = "{icon} {volume:02}%";
            "format-muted" = "󰝟";
            "format-icons" = {
              "default" = [
                ""
                "󰖀"
                "󰕾"
              ];
            };
            "on-click-right" = "exec pwvucontrol";
            "on-click" = "wpctl set-mute @DEFAULT_SINK@ toggle";
          };
        }
      ];
    };
  };
}
