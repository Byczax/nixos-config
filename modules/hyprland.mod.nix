{ config, pkgs, lib, ... }:

let
  cfg = config.module.hyprland;
in {
  options.module.hyprland.enable = lib.mkEnableOption "Enable custom hyprland config";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
      "$mod" = "SUPER";
      "$print" = "XF86SelectiveScreenshot";
      "$terminal" = "foot";
      "$fileManager" = "thunar";
      "$menu" = "wofi -G --allow-images --show drun";
      exec-once = [
        "$terminal &"
        "waybar &"
        "flameshot &"
        "kdeconnectd &"
      ];
      exec = [
        "hyprshade auto"
      ];
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
      };
      input = {
        "kb_layout"="pl";
        };
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, L, exec, hyprlock"
        "$mod, D, exec, vesktop"
        "$mod, Return, exec, $terminal"
        "$mod, $print, exec, grimblast copy area"
        ", $print, exec, flameshot gui 2>/dev/null"
        #"$mod, F, exec, firefox"

        "$mod, F, fullscreen" 

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move window with mod + arrow keys
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        "$mod, t, togglegroup"
        "$mod, k, changegroupactive, f"
        "$mod, j, changegroupactive, b"



        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ] ++ (
          builtins.concatLists (builtins.genList (i: let ws = i; in [
                "$mod, ${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
              ] ) 10)
      );
      bindm = [
      # Move/resize windows with mod + LMB/RMB and dragging
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        ",switch:Lid Switch, exec, hyprlock"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      source = [ "~/.config/hypr/monitors.conf" ];

      windowrulev2 = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        
        # moves the window to x0, y0 on the screen
        "move 0 0,class:(flameshot),title:(flameshot)"
        # shows the window on all workspaces
        "pin,class:(flameshot),title:(flameshot)"
        # tell the application it's in fullscreen mode
        "fullscreenstate,class:(flameshot),title:(flameshot)"
        # force the window to be floating ( not in a tiled pane )
        "float,class:(flameshot),title:(flameshot)"

        ];	
      };
    };

    # TODO decoration
    # TODO animations
    #

    home.file.".config/hypr/hyprshade.toml".text = ''
      [[shades]]
      name = "vibrance"
      default = true  # will be activated when no other shader is scheduled

      [[shades]]
      name = "blue-light-filter"
      start_time = 19:00:00
      end_time = 06:00:00   # optional if more than one shader has start_time
    '';
  };
}

