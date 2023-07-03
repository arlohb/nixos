{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # FIXME https://github.com/NixOS/nixpkgs/issues/241125
    nixpkgs-blender.url = "github:NixOS/nixpkgs?rev=73b1a45dd79e414c2546fd89b47f51b3dea3e6f9";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Manages persistant files when / is a tmpfs
    impermanence.url = "github:nix-community/impermanence";

    # A nvim plugin not (yet) in nixpkgs
    nvim-spider.url = "github:chrisgrieser/nvim-spider";
    nvim-spider.flake = false;

    # A simple timer.
    # I have to build this myself.
    # For now this is an input here,
    # but ideally this would be its own flake.
    porsmo.url = "github:ColorCookie-dev/porsmo";
    porsmo.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-blender, nur, home-manager, hyprland, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages."${system}".pkgs;
      pkgs-blender = nixpkgs-blender.legacyPackages."${system}".pkgs;
      blenderFix = {
        nixpkgs.config.packageOverrides = pkgs: {
          blender = pkgs-blender.blender;
        };
      };

      utils = import ./conf/utils.nix;

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

        blenderFix

        hyprland.nixosModules.default
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ] ++ (utils.loadBetterModules { inherit hostname inputs; } [
        ./conf/core.nix
        ./conf/hardware.nix
        ./conf/user.nix
        ./conf/audio.nix
        ./conf/terminal.nix
        ./conf/git.nix
        ./conf/neovim/neovim.nix
        ./conf/wm/core.nix
        ./conf/wm/cursor.nix
        ./conf/wm/lockscreen.nix
        ./conf/wm/notifications.nix
        ./conf/wm/polkit.nix
        ./conf/wm/hypr/hypr.nix
        ./conf/programs.nix
        ./conf/gaming.nix
        ./conf/3d.nix
      ]);
    in
    {
      # Build this with:
      # nix build .#nixosConfigurations.live.config.system.build.isoImage
      nixosConfigurations.live = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          nurModule
          ({ pkgs, config, lib, ... }@moduleInputs: utils.betterModule { hostname = "nix-live"; } (import ./conf/core.nix) moduleInputs)
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

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
        ];
      };
    };
}
