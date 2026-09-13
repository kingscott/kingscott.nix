# mDNS/DNS-SD so CUPS can discover driverless (IPP Everywhere/AirPrint)
# printers and hosts can reach each other as <hostname>.local.
{ ... }: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    # Announce the host's own address record so <hostname>.local resolves
    # across machines. publish.enable is the master switch — without it the
    # daemon runs with disable-publishing=yes and ignores the options below.
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
