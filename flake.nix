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
    # Zen isn't in nixpkgs (Mozilla branding/redistribution), so it comes from
    # the upstream community flake.
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, claude-desktop, niri, zen-browser, ... }:
    let
      # Shared across every machine: desktop, packages, window manager, and
      # home-manager wiring. Per-machine hardware lives under ./machines/<name>.
      sharedModules = [
        ./modules/common.nix
        ./modules/avahi.nix
        ./modules/niri.nix
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ zen-browser.homeModules.beta ];
        }
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            claude-desktop.overlays.default
            # niri-flake's package expression asserts on libdisplay-info 0.2.0,
            # which nixpkgs removed as unused (sodiboo/niri-flake#1851).
            # Reintroduce it until niri-flake drops the dependency.
            (final: prev: {
              libdisplay-info_0_2 = prev.libdisplay-info_0_3.overrideAttrs (old: {
                version = "0.2.0";
                src = prev.fetchFromGitLab {
                  domain = "gitlab.freedesktop.org";
                  owner = "emersion";
                  repo = "libdisplay-info";
                  tag = "0.2.0";
                  hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
                };
              });
            })
          ];
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
