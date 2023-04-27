{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

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
    neofsharp-vim.url = "github:adelarsq/neofsharp.vim";
    neofsharp-vim.flake = false;
  };

  outputs = { self, nixpkgs, nur, home-manager, hyprland, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages."${system}".pkgs;

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
          home-manager.users.arlo.imports = [ ./conf/home.nix ./conf/neovim/neovim.nix ];
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
    in
    {
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

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
        ];
      };
    };
}
