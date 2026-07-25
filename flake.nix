{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, claude-desktop, niri, ... }:
    let
      # Shared across every machine: desktop, packages, window manager, and
      # home-manager wiring. Per-machine hardware lives under ./machines/<name>.
      sharedModules = [
        ./modules/common.nix
        ./modules/niri.nix
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ claude-desktop.overlays.default ];
          environment.systemPackages = [ pkgs.claude-desktop ];
        })
      ];
    in
    {
      nixosConfigurations.dbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          ./machines/dbook
          {
            home-manager.users.kingscott.imports = [ ./home ./machines/dbook/home.nix ];
          }
        ];
      };

      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          ./machines/framework
          nixos-hardware.nixosModules.framework-13-7040-amd
          {
            home-manager.users.kingscott.imports = [ ./home ];
          }
        ];
      };
    };
}
