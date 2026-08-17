{
  config,
  pkgs,
  lib,
  compositor,
  ...
}: let
  cfg = config.modules.waybar;
  # Left-side workspace/window modules follow the active compositor.
  wsModules =
    if compositor == "niri"
    then ["niri/workspaces" "niri/window"]
    else ["hyprland/workspaces" "hyprland/window"];
in {
  options.modules.waybar.enable = lib.mkEnableOption "Enable custom waybar config";

  config = lib.mkIf cfg.enable {
    # Run waybar as a systemd user service so it survives monitor hotplug
    # (docking/undocking). Without a supervisor waybar dies when its output
    # disappears and never comes back until manual restart.
    systemd.user.services.waybar.Service = {
      Restart = lib.mkForce "always";
      RestartSec = lib.mkForce "1";
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        # graphical-session.target is reached under both hyprland and niri, so
        # the bar starts regardless of compositor.
        targets = ["graphical-session.target"];
      };
      style = ./waybar_style.css;
      settings = [
        {
          "layer" = "top";
          "position" = "top";
          modules-left = wsModules;
          modules-center = [];
          modules-right = [
            "tray"
            "network"
            "wireplumber"
            "wireplumber#mic"
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

            "on-click-right" = "pwvucontrol";
            "on-click" = "wpctl set-mute @DEFAULT_SINK@ toggle";
          };
          "wireplumber#mic" = {
            "node-type" = "Audio/Source";
            "format" = "󰍬";
            "format-muted" = "󰍭";
            #"tooltip-format" = "{node_name}\nVolume: {volume}%";
            "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            "on-click-right" = "pavucontrol";
            "scroll-step" = 5;
          };
        }
      ];
    };
  };
}
