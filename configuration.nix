# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let
    dwm-session = pkgs.writeShellScriptBin "dwm-session" ''
      ${pkgs.feh}/bin/feh --bg-fill ~/workspace/dotfiles-wm/dwm/backgrounds/20260410_barcelona-narbonne-0258-sk.JPEG &
      ${pkgs.redshift}/bin/redshift &
      ${pkgs.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
      ${pkgs.dunst}/bin/dunst &
      ${pkgs.dwmblocks}/bin/dwmblocks &
      exec ${pkgs.dwm}/bin/dwm
    '';
    dwm-xsession = pkgs.runCommand "dwm-xsession" {
      passthru.providedSessions = [ "dwm" ];
    } ''
      mkdir -p $out/share/xsessions
      cat > $out/share/xsessions/dwm.desktop <<EOF
      [Desktop Entry]
      Name=dwm
      Exec=${dwm-session}/bin/dwm-session
      Type=XSession
      EOF
    '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
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

  networking.hostName = "dbook"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable flake support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sessionPackages = [ dwm-xsession ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kingscott = {
    isNormalUser = true;
    description = "Scott King";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow dwm (+ dwmblocks) to be built from a local dir with specific folder structure.
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (_: {
        src = /home/kingscott/workspace/dotfiles-wm/dwm;
      });
      dwmblocks = prev.stdenv.mkDerivation {
        pname = "dwmblocks";
        version = "custom";
        src = /home/kingscott/workspace/dotfiles-wm/dwmblocks;
        nativeBuildInputs = [ prev.pkg-config ];
        buildInputs = [ prev.xcbutil ];
        makeFlags = [ "PREFIX=$(out)" ];
      };
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    claude-code
    dunst
    dwm
    dwmblocks
    dwm-session
    fastfetch
    feh
    gcc
    gnumake
    gh
    ghostty
    git
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
    redshift
    ripgrep
    rofi
    setxkbmap
    wget
    xclip
    xinit
    xinput
  ];


  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.82"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
