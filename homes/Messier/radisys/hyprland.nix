{
  exec-once = [
    "waybar"
    "hyprpaper"
    "nm-applet"
    "blueman-applet"
    "swaync"
    "udiskie &"
    "dbus-update-activation-environmnt --systemd DISPLAY WAYLAND-DISPLAY"
    "bash ~/.config/lockonsleep/config.sh"
  ];

   monitor = [
    "eDP-1,1920x1080,0x0,1"
  ];

  "env" = "XCURSOR_SIZE,24";
  "$mod" = "SUPER";
  input = {
    kb_layout = "gb";
    kb_variant = "colemak";
    follow_mouse = 1;
    touchpad.natural_scroll = "no";
    sensitivity = -0.5;
  };

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };
    drop_shadow = "yes";
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

    dwindle = {
      pseudotile = true;
      preserve_split = "yes";
    };

    master = {
      new_is_master = true;
    };

    gestures = {
      workspace_swipe = false;
    };

    misc = {
      disable_hyprland_logo = true;
    };
    binde = [
      # Volume stuffs
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
    ];
    bind = [
      # basic binds
      "$mod, Q, exec, kitty"
      "$mod, C, killactive, "
      "$mod, M, exit, "
      "$mod, V, togglefloating, "
      "$mod, R, exec, wofi --show drun"
      "$mod, E, exec, nemo"
      "$mod, P, pseudo,"
      "$mod, J, togglesplit,"
      "$mod, K, exec, hyprctl dispatch exit"
      "$mod, S, exec, grim -g \"$(slurp)\""
      "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mod, left, movewindow, l"
      "$mod, right, movewindow, r"
      "$mod, up, movewindow, up"
      "$mod, down, movewindow, down"
      # Brightness (I like my mostly non-functional eyes)
      ", XF86MonBrightnessUp, exec, brightnessctl --device=amdgpu_bl0 s +10"
      ", XF86MonBrightnessDown, exec, brightnessctl --device=amdgpu_bl0 s 10-"
      # Switch workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
      # Move a window to a given workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
      # Use mouse to scroll through existing workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    "device:etps/2-elantech-touchpad" = {
      enabled = false;
    };
}

