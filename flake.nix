rec {
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # Manages persistant files when / is a tmpfs
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, nur, home-manager, hyprland, impermanence }: let
    system = "x86_64-linux";

    # A module that loads nur
    nurModule = {
      nixpkgs.config.packageOverrides = pkgs: {
        nur = import nur {
          inherit pkgs;
          nurpkgs = import nixpkgs { inherit system; };
        };
      };
    };

    fullModules = hostname: [
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

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.arlo.imports = [ ./conf/home.nix ];
        home-manager.users.root.imports = [ ./conf/root-home.nix ];
      }
    ] ++ (map (path: import path hostname) [
      ./conf/hardware.nix
      ./conf/persistence.nix
      ./conf/core.nix
      ./conf/base.nix
      ./conf/audio.nix
      ./conf/wm.nix
      ./conf/gaming.nix
    ]);
  in {
    # Build this with:
    # nix build .#nixosConfigurations.live.config.system.build.isoImage
    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        (import ./conf/core.nix "nix-live")
        nurModule
      ];
    };

    nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = fullModules "arlo-laptop2";
    };

    nixosConfigurations.arlo-nix = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = fullModules "arlo-nix";
    };
  };
}
