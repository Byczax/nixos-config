waybarCSS:
{
  enable = true;
  style = waybarCSS;
  settings = [
    {
      "layer" = "top";
      "position" = "top";
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
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
        "on-click" = "exec alacritty -e nmtui";
      };
      
      "bluetooth" = {
        "format" = " {status}";
        "format-disabled" = ""; #// an empty format will hide the module
        "format-connected" = " {num_connections} connected";
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
        "format" = "  {used:0.1f}G/{total:0.1f}G ";
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
        "format" = "{:%H:%M}";
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
}
