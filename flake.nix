{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, claude-desktop, niri, ... }: {
    nixosConfigurations.dbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./machines/dbook
        ./modules/common.nix
        ./modules/niri.nix
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kingscott = {
            imports = [ ./home ./machines/dbook/home.nix ];
          };
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            claude-desktop.overlays.default
          ];
          environment.systemPackages = [
            pkgs.claude-desktop
          ];
        })
      ];
    };
  };
}
