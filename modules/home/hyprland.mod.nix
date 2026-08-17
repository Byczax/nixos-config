{
  config,
  pkgs,
  lib,
  compositor,
  ...
}: let
  cfg = config.modules.hyprland;

  randomWall = pkgs.writeShellScript "random-wall" ''
    DIR="$HOME/nixos-config/assets/"
    ${pkgs.hyprland}/bin/hyprctl hyprpaper unload all

    for MON in $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name'); do
      WALL=$(find "$DIR" -type f | shuf -n 1)
      ${pkgs.hyprland}/bin/hyprctl hyprpaper preload "$WALL"
      ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper "$MON,$WALL"
      sleep 1
    done
  '';
in {
  # Defaults to on only when this host boots hyprland. Flip meta.compositor to
  # "niri" and this turns itself off (and modules/home/niri.mod.nix turns on).
  options.modules.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = compositor == "hyprland";
    description = "Enable custom hyprland config";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      # Lua config backend (Hyprland 0.5x). The whole config is authored as
      # native Lua via extraConfig (appended to ~/.config/hypr/hyprland.lua);
      # `hl` is the global Hyprland Lua API. settings is left empty.
      configType = "lua";
      enable = true;
      systemd.enable = true;
      settings = {};
      extraConfig = ''
        -- Variables
        local mod         = "SUPER"
        local printKey    = "XF86SelectiveScreenshot"
        local terminal    = "foot"
        local fileManager = "thunar"
        local menu        = "wofi -G --allow-images --show drun"
        local clipboard   = "cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        -- Environment
        hl.env("XCURSOR_SIZE", "24")
        hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

        -- Keyword config (general / input)
        hl.config({
          general = { gaps_in = 0, gaps_out = 0, border_size = 0 },
          input   = { kb_layout = "pl", kb_options = "grp:alt_shift_toggle" },
        })

        -- Monitors: sane default for every output — native (preferred) mode,
        -- auto position, scale 1. kanshi overrides per-profile when docked.
        -- scale "auto" was picking a fractional/2x scale on some panels (the
        -- "zoomed in" look), so pin it to 1.
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

        -- Autostart (waybar is started by its systemd user service)
        hl.on("hyprland.start", function()
          hl.exec_cmd(terminal)
          -- Qt overlay broken under native Wayland; force XWayland for flameshot UI
          hl.exec_cmd("QT_QPA_PLATFORM=xcb XDG_CURRENT_DESKTOP=sway flameshot")
          hl.exec_cmd("kdeconnectd")
          hl.exec_cmd("bash -c 'while true; do ${randomWall}; sleep 6000; done'")
          hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
          hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        end)

        -- Applications
        hl.bind(mod .. " + Q",      hl.dsp.exec_cmd(terminal))
        hl.bind(mod .. " + C",      hl.dsp.window.close())
        hl.bind(mod .. " + M",      hl.dsp.exit())
        hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager))
        hl.bind(mod .. " + B",      hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mod .. " + R",      hl.dsp.exec_cmd(menu))
        hl.bind(mod .. " + P",      hl.dsp.window.pseudo())
        hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
        hl.bind(mod .. " + D",      hl.dsp.exec_cmd("vesktop"))
        hl.bind(mod .. " + V",      hl.dsp.exec_cmd(clipboard))
        hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
        hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())

        -- Screenshots
        hl.bind(printKey,                        hl.dsp.exec_cmd("grimblast --freeze copy area"))
        hl.bind(mod .. " + " .. printKey,        hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | satty -f -"))
        hl.bind(mod .. " + CTRL + " .. printKey, hl.dsp.exec_cmd("QT_QPA_PLATFORM=xcb XDG_CURRENT_DESKTOP=sway flameshot gui"))

        -- Focus movement
        hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
        hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
        hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

        -- Move window
        hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
        hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
        hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
        hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

        -- Groups
        hl.bind(mod .. " + T", hl.dsp.group.toggle())
        hl.bind(mod .. " + K", hl.dsp.group.next())
        hl.bind(mod .. " + J", hl.dsp.group.prev())

        -- Special workspace (scratchpad)
        hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
        hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

        -- Scroll through workspaces
        hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

        -- Workspaces 1..10 (key 0 = workspace 10)
        for i = 1, 10 do
          local key = i % 10
          hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
          hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Mouse drag / resize
        hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Lid close -> route through the guarded session locker (hypridle lock_cmd)
        hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })

        -- Volume / brightness (work while locked, key-repeat)
        hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true, repeating = true })
        hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true, repeating = true })
        hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),{ locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 5%+"),                        { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"),                        { locked = true, repeating = true })

        -- Media keys
        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

        -- Window rules
        hl.window_rule({
          name = "flameshot", match = { class = "^(flameshot)$" },
          float = true, move = "0 0", pin = true, no_anim = true,
          suppress_event = "fullscreen", monitor = 1,
        })
        hl.window_rule({
          name = "satty", match = { class = "^(com.gabm.satty)$" },
          float = true, center = true, size = "80% 80%",
        })
        hl.window_rule({
          name = "zoom", match = { title = "^(zoom)$" }, float = true,
        })

        -- NOTE: the hyprlang monitors.conf (written by nwg-displays) cannot be
        -- sourced from Lua (no hl.source). The default hl.monitor above covers
        -- the internal panel; kanshi manages docked multi-monitor layouts.
      '';
    };

    services.hyprpaper = {
      enable = true;
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
    };

    # TODO decoration
    # TODO animations
    #

    # home.file.".config/hypr/hyprshade.toml".text = ''
    #   [[shades]]
    #   name = "vibrance"
    #   default = true  # will be activated when no other shader is scheduled
    #
    #   [[shades]]
    #   name = "blue-light-filter"
    #   start_time = 19:00:00
    #   end_time = 06:00:00   # optional if more than one shader has start_time
    # '';
  };
}
