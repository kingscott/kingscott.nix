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
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Thunderbolt device authorization (docks, eGPUs).
  services.hardware.bolt.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # The SELPHY CP1300 is driverless (IPP Everywhere/AirPrint) over the network;
  # it advertises pdl=image/urf,image/pwg-raster. No vendor driver package —
  # Gutenprint's SELPHY support is for USB and produces the wrong raster here.
  services.printing.enable = true;

  # gvfs backs Nautilus's trash, mounting, and network browsing. Without it
  # "move to trash" and remote/removable locations silently don't work.
  services.gvfs.enable = true;

  # mDNS lives in ./avahi.nix.

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
    # cdrom: optical drives are GROUP="cdrom" via the default udev rules,
    # so ripping needs membership to open /dev/sr0.
    extraGroups = [ "networkmanager" "wheel" "video" "cdrom" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # CD ripping. Was asunder, but its rip-completion path calls gtk_dialog_run()
    # from a worker thread while holding the GDK lock (legacy gdk_threads_init),
    # which deadlocks the UI after every rip. Sound Juicer is a plain GTK app
    # with none of that; it rips to FLAC directly. flac/cdparanoia are here for
    # the command-line side (metaflac, drive testing); picard for tagging.
    sound-juicer
    cdparanoia
    flac
    picard

    amp-cli
    brightnessctl
    calibre
    claude-code
    dfu-util
    fastfetch
    gcc
    gnumake
    gh
    handbrake
    kdePackages.okular
    libnotify
    libreoffice
    libxcb
    libxcb-util
    libX11
    libxft
    libxinerama
    localsend
    nautilus
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
    t3code
    vlc
    wget
    xclip
    xinit
    xinput
  ];

  networking.firewall = {
    allowedTCPPorts = [
      9090  # Calibre wireless device connection
      53317 # LocalSend
    ];
    allowedUDPPorts = [
      53317 # LocalSend discovery
      54982 48123 39001 44044 59678  # Calibre wireless device auto-discovery
    ];
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
