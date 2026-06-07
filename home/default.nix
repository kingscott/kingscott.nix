{ ... }: {
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/rofi.nix
    ./programs/ghostty.nix
    ./programs/dunst.nix
    ./programs/mako.nix
    ./programs/fuzzel.nix
    ./programs/niri.nix
    ./programs/noctalia.nix
    ./xdg.nix
  ];

  home.username = "kingscott";
  home.homeDirectory = "/home/kingscott";
  home.stateVersion = "25.11";
}
