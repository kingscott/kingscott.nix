{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "dbook";

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.82"
  ];
}
