{ config, pkgs, ... }:

let
  dwm-session = pkgs.writeShellScriptBin "dwm-session" ''
    ${pkgs.feh}/bin/feh --bg-fill ~/workspace/dotfiles-wm/dwm/backgrounds/20260410_barcelona-narbonne-0258-sk.JPEG &
    ${pkgs.redshift}/bin/redshift &
    ${pkgs.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
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
  services.displayManager.sessionPackages = [ dwm-xsession ];

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

  environment.systemPackages = with pkgs; [
    brightnessctl
    claude-code
    dwm
    dwmblocks
    dwm-session
    fastfetch
    feh
    gcc
    gnumake
    gh
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
    redshift
    ripgrep
    setxkbmap
    tailscale
    toybox
    wget
    xclip
    xinit
    xinput
  ];

  system.stateVersion = "25.11";
}
