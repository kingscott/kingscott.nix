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
}
