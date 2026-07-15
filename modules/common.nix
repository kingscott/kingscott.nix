{ config, pkgs, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old-generations 5";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=kingscott" ];
  };

  services.udev.packages = [ pkgs.brightnessctl ];

  users.users.kingscott = {
    isNormalUser = true;
    description = "Scott King";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    calibre
    claude-code
    dfu-util
    fastfetch
    gcc
    gnumake
    gh
    kdePackages.okular
    libnotify
    libxcb
    libxcb-util
    libX11
    libxft
    libxinerama
    localsend
    neovim
    nerd-fonts.caskaydia-cove
    openssh
    pavucontrol
    pulseaudio
    qmk
    ripgrep
    setxkbmap
    tailscale
    toybox
    typora
    vlc
    wget
    xclip
    xinit
    xinput
  ];

  networking.firewall = {
    allowedTCPPorts = [
      9090  # Calibre content server
      53317 # LocalSend
    ];
    allowedUDPPorts = [
      53317 # LocalSend discovery
    ];
  };

  system.stateVersion = "25.11";
}
