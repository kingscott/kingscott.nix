{ lib, ... }: {
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
      { command = [ "swaybg" "-i" "/home/kingscott/Pictures/Wallpapers/20260410_barcelona-narbonne-0258-sk.JPEG" "-m" "fill" ]; }
      { command = [ "gammastep" ]; }
      { command = [ "xwayland-satellite" ]; }
      { command = [ "trayscale" "--hide-window" ]; }
    ];

    input = {
      keyboard.xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true;
      };
      focus-follows-mouse.enable = false;
    };

    layout = {
      gaps = 15;
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 3;
        active.color = "#c4a7e7";
        inactive.color = "#1f1d2e";
      };
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#00000070";
      };
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 0.55; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = { proportion = 0.5; };
    };

    prefer-no-csd = true;

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-left = 10.0;
          bottom-right = 10.0;
        };
        clip-to-geometry = true;
      }
    ];

    binds = with lib.attrsets;
      let
        sh = cmd: { action.spawn = [ "sh" "-c" cmd ]; };
        run = args: { action.spawn = args; };
      in
      mapAttrs (_: v: v) {
        # Launchers / terminal
        "Mod+R" = run [ "fuzzel" ];
        "Mod+Space" = run [ "fuzzel" ];
        "Mod+Shift+Return" = run [ "ghostty" ];

        # Screenshot
        "Print" = { action.screenshot = { }; };
        "Mod+Print" = { action.screenshot-window = { }; };
        "F11" = sh "region=$(slurp) || exit; grim -g \"$region\" - | wl-copy";

        # Audio
        "XF86AudioMute" = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
        "XF86AudioRaiseVolume" = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+";

        # Brightness
        "XF86MonBrightnessUp" = run [ "brightnessctl" "set" "+5%" ];
        "XF86MonBrightnessDown" = run [ "brightnessctl" "set" "5%-" ];

        # Media
        "XF86AudioPlay" = run [ "playerctl" "play-pause" ];
        "XF86AudioNext" = run [ "playerctl" "next" ];
        "XF86AudioPrev" = run [ "playerctl" "previous" ];

        # Focus across columns
        "Mod+J" = { action.focus-column-right = { }; };
        "Mod+K" = { action.focus-column-left = { }; };
        # Within-column stack navigation
        "Mod+Ctrl+J" = { action.focus-window-down = { }; };
        "Mod+Ctrl+K" = { action.focus-window-up = { }; };
        # Resize column
        "Mod+H" = { action.set-column-width = "-5%"; };
        "Mod+L" = { action.set-column-width = "+5%"; };

        # Move windows
        "Mod+Shift+J" = { action.move-column-right = { }; };
        "Mod+Shift+K" = { action.move-column-left = { }; };
        "Mod+Ctrl+Shift+J" = { action.move-window-down = { }; };
        "Mod+Ctrl+Shift+K" = { action.move-window-up = { }; };

        # Move focused column to first position
        "Mod+Return" = { action.move-column-to-first = { }; };

        # Previous workspace
        "Mod+Tab" = { action.focus-workspace-previous = { }; };

        # Kill window
        "Mod+Shift+Q" = { action.close-window = { }; };

        # Layouts
        "Mod+F" = { action.maximize-column = { }; };
        "Mod+Shift+F" = { action.fullscreen-window = { }; };
        "Mod+M" = { action.fullscreen-window = { }; };
        "Mod+Shift+Space" = { action.toggle-window-floating = { }; };
        "Mod+W" = { action.switch-preset-column-width = { }; };

        # Monitors
        "Mod+Comma" = { action.focus-monitor-left = { }; };
        "Mod+Period" = { action.focus-monitor-right = { }; };
        "Mod+Shift+Comma" = { action.move-column-to-monitor-left = { }; };
        "Mod+Shift+Period" = { action.move-column-to-monitor-right = { }; };

        # Workspaces 1..9
        "Mod+1" = { action.focus-workspace = 1; };
        "Mod+2" = { action.focus-workspace = 2; };
        "Mod+3" = { action.focus-workspace = 3; };
        "Mod+4" = { action.focus-workspace = 4; };
        "Mod+5" = { action.focus-workspace = 5; };
        "Mod+6" = { action.focus-workspace = 6; };
        "Mod+7" = { action.focus-workspace = 7; };
        "Mod+8" = { action.focus-workspace = 8; };
        "Mod+9" = { action.focus-workspace = 9; };
        "Mod+Shift+1" = { action.move-column-to-workspace = 1; };
        "Mod+Shift+2" = { action.move-column-to-workspace = 2; };
        "Mod+Shift+3" = { action.move-column-to-workspace = 3; };
        "Mod+Shift+4" = { action.move-column-to-workspace = 4; };
        "Mod+Shift+5" = { action.move-column-to-workspace = 5; };
        "Mod+Shift+6" = { action.move-column-to-workspace = 6; };
        "Mod+Shift+7" = { action.move-column-to-workspace = 7; };
        "Mod+Shift+8" = { action.move-column-to-workspace = 8; };
        "Mod+Shift+9" = { action.move-column-to-workspace = 9; };

        # Quit niri
        "Mod+Shift+C" = { action.quit = { }; };
      };
  };
}
