rec {
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, nur, home-manager, hyprland, impermanence }: let
    system = "x86_64-linux";

    nurModule = {
      nixpkgs.config.packageOverrides = pkgs: {
        nur = import nur {
          inherit pkgs;
          nurpkgs = import nixpkgs { inherit system; };
        };
      };
    };
  in {
    # Build this with:
    # nix build .#nixosConfigurations.live.config.system.build.isoImage
    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        ./conf/core.nix
        nurModule
      ];
    };

    nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        nurModule

        hyprland.nixosModules.default
        {
          programs.hyprland = {
            enable = true;
            nvidiaPatches = false;
            xwayland.hidpi = false;
          };
        }

        impermanence.nixosModules.impermanence

        ./hardware-configuration.nix
        ./conf/core.nix
        ./conf/persistence.nix
        ./conf/base.nix
        ./conf/gaming.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.arlo.imports = [ ./conf/home.nix ];
          home-manager.users.root.imports = [ ./conf/root-home.nix ];
        }
      ];
    };
  };
}
