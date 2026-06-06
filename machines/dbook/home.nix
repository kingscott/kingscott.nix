{ ... }: {
  # MacBook (Apple SMC) keyboard backlight controls.
  programs.niri.settings.binds = {
    "XF86KbdBrightnessUp" = {
      action.spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "+10%" ];
    };
    "XF86KbdBrightnessDown" = {
      action.spawn = [ "brightnessctl" "--device=smc::kbd_backlight" "set" "10%-" ];
    };
  };
}
