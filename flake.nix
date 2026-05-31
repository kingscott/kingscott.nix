{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, claude-desktop, zen-browser, ... }: {
    nixosConfigurations.dbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./machines/dbook
        ./modules/common.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kingscott = import ./home;
        }
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
