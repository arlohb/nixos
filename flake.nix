rec {
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nur, home-manager, hyprland }: rec {
    system = "x86_64-linux";

    nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        {
          nixpkgs.config.packageOverrides = pkgs: {
            nur = import nur {
              inherit pkgs;
              nurpkgs = import nixpkgs { inherit system; };
            };
          };
        }

        hyprland.nixosModules.default
        {
          programs.hyprland = {
            enable = true;
            nvidiaPatches = false;
            xwayland.hidpi = false;
          };
        }

        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.arlo.imports = [ ./conf/home.nix ];
        }
      ];
    };
  };
}
