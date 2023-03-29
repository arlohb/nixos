rec {
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, home-manager, hyprland }: {
    nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hyprland.nixosModules.default
	{ programs.hyprland = {
	  enable = true;
	  nvidiaPatches = false;
	  xwayland.hidpi = false;
	};}
        ./configuration.nix
	home-manager.nixosModules.home-manager {
	  home-manager.useGlobalPkgs = true;
	  home-manager.extraSpecialArgs = { inherit inputs; };
	  home-manager.users.arlo.imports = [ ./conf/home.nix ];
	}
      ];
    };
  };
}
