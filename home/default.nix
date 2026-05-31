{ ... }: {
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/rofi.nix
    ./programs/ghostty.nix
    ./programs/dunst.nix
  ];

  home.username = "kingscott";
  home.homeDirectory = "/home/kingscott";
  home.stateVersion = "25.11";
}
