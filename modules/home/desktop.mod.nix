{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.desktop.enable = lib.mkEnableOption "Wayland desktop stack shared by all laptops";

  config = lib.mkIf config.modules.desktop.enable {
    home.file.".config/electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform-hint=auto
    '';

    programs = {
      hyprlock.enable = true;
      wofi.enable = true;
      foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "Fira Code:size=11";
          };
          cursor = {
            style = "beam";
            blink = "no";
          };
          url = {
            osc8-underline = "always";
            launch = "xdg-open \${url}";
          };
        };
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-gstreamer
          obs-vkcapture
        ];
      };
      zathura = {
        enable = true;
        extraConfig = "set selection-clipboard clipboard";
      };
      mpv = {
        enable = true;
        config = {
          profile = "high-quality";
          ytdl-format = "bestvideo+bestaudio";
          save-position-on-quit = "yes";
        };
      };
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };
      hyprpolkitagent.enable = true;
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            # Respawn the locker if it crashed on the monitor change during sleep.
            after_sleep_cmd = "hyprctl dispatch dpms on; pidof hyprlock || hyprlock";
            ignore_dbus_inhibit = false;
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 900;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
      wlsunset = {
        enable = true;
        latitude = 47.4;
        longitude = 8.6;
        temperature = {
          day = 4200;
          night = 2000;
        };
      };
      mako = {
        enable = true;
        settings = {
          default-timeout = 4000;
          "urgency=low" = {
            "border-color" = "#313244";
            "default-timeout" = "2000";
          };
          "urgency=normal" = {
            "border-color" = "#313244";
            "default-timeout" = "5000";
          };
          "urgency=high" = {
            "border-color" = "#f38ba8";
            "text-color" = "#f38ba8";
            "default-timeout" = "0";
          };
        };
      };
      # hyprland.mod.nix starts flameshot and binds cliphist, so both belong to the shared stack.
      flameshot = {
        enable = true;
        package = pkgs.flameshot.override {enableWlrSupport = true;};
        settings.General = {
          # Without the grim adapter, flameshot gives black shots under Hyprland.
          useGrimAdapter = true;
          disabledGrimWarning = true;
          saveAsFileExtension = ".png";
          showDesktopNotification = true;
          showHelp = true;
          showSidePanelButton = true;
          uiColor = "#740096";
          contrastUiColor = "#270032";
          drawColor = "#ff0000";
        };
      };
      cliphist = {
        enable = true;
        systemdTargets = ["graphical-session.target"];
        extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
        allowImages = true;
      };
    };
  };
}
