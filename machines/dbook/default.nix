{ pkgs, ... }:

let
  set-power-profile = pkgs.writeShellScript "set-power-profile" ''
    online=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null || echo "1")
    if [ "$online" = "1" ]; then
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
    else
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
    fi
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "dbook";

  # SSH access from the framework machine; its key is authorized for
  # key/config transfers between machines on the LAN.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  users.users.kingscott.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCvo9n8iKckTVwA+nARt2C9QDP+UHRY2f/UqFt+NOhy me@kingscott.ca"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.82"
  ];

  services.logind = {
    settings = {
      Login.HandleLidSwitch = "suspend";
      Login.HandleLidSwitchExternalPower = "suspend";
    };
  };

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
