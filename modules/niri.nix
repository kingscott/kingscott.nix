{ pkgs, ... }: {
  programs.niri.enable = true;

  # XDG portals for Wayland (screenshots, screen share, file pickers).
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Wayland session bits + the NNN shell.
  environment.systemPackages = with pkgs; [
    noctalia-shell
    quickshell
    mako
    fuzzel
    swaybg
    gammastep
    wl-clipboard
    xwayland-satellite
    grim
    slurp
    wlr-randr
    imagemagick
    playerctl
    trayscale
  ];
}
