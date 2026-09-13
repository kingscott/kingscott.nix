{ pkgs, ... }:

let
  set-power-profile = pkgs.writeShellScript "set-power-profile" ''
    online=$(cat /sys/class/power_supply/ACAD/online 2>/dev/null || echo "1")
    if [ "$online" = "1" ]; then
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
    else
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
    fi
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "framework";

  # Framework ships firmware via LVFS; fwupd lets `fwupdmgr` apply BIOS/EC
  # updates. Most other Framework 13 (AMD 7040) quirks come from the
  # nixos-hardware module wired up in flake.nix.
  services.fwupd.enable = true;

  # Switch power profile based on AC state. The Framework 13 AMD exposes its
  # mains adapter as ACAD (the MacBook uses ADP1).
  systemd.services.power-profile-switch = {
    description = "Switch power profile based on AC state";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${set-power-profile}";
    };
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl start --no-block power-profile-switch.service"
  '';

  # Fingerprint reader — Goodix MOC in the power button (USB 27c6:609c),
  # driven by libfprint's goodixmoc. nixos-hardware's framework/13-inch/common
  # already switches fprintd on; saying so here makes the dependency visible
  # and keeps the reader working if that module is ever dropped.
  #
  # PAM wires itself up from this: security.pam.services.*.fprintAuth defaults
  # to services.fprintd.enable, so login, sudo, polkit and SDDM all accept a
  # finger, and noctalia's lock screen authenticates through /etc/pam.d/login.
  # Fingers still have to be enrolled per user — `fprintd-enroll`.
  services.fprintd.enable = true;

  # Trackpad (PIXA3854 I2C touchpad, driven by i2c_hid_acpi + hid_multitouch).
  #
  # The niri session configures the pad itself — see home/programs/niri.nix.
  # These options only reach X11 sessions (Plasma on X11, anything under
  # startx), and exist so the pad behaves identically whichever session is
  # picked at the login screen.
  services.libinput.touchpad = {
    tapping = true;
    tappingDragLock = true;
    # Tap with 1/2/3 fingers = left/right/middle.
    tappingButtonMap = "lrm";
    naturalScrolling = true;
    scrollMethod = "twofinger";
    accelProfile = "adaptive";
    disableWhileTyping = true;
    # The pad is one large physical button, so clicks go by finger count
    # rather than click zones: 2 fingers = right-click, 3 = middle-click.
    clickMethod = "clickfinger";
  };

  # `libinput list-devices` to confirm what the pad reports, `libinput
  # debug-events` to watch taps and swipes live. The input group lets both
  # run without root.
  environment.systemPackages = [ pkgs.libinput ];
  users.users.kingscott.extraGroups = [ "input" ];
}
