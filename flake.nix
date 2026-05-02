{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-desktop, zen-browser, ... }: {
    nixosConfigurations.dbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./machines/dbook
        ./modules/common.nix
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            claude-desktop.overlays.default
          ];
          environment.systemPackages = [
            pkgs.claude-desktop
            zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })
      ];
    };
  };
}
