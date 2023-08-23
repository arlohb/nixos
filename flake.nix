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
    obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
    obsidian-nvim.flake = false;
    drop-nvim.url = "github:folke/drop.nvim";
    drop-nvim.flake = false;

    # A simple timer.
    # I have to build this myself.
    # For now this is an input here,
    # but ideally this would be its own flake.
    porsmo.url = "github:ColorCookie-dev/porsmo?rev=37528c9c4421c5be853a0509812c23ec60c3eca1";
    porsmo.flake = false;
  };

  outputs = { self, nixpkgs, nur, home-manager, hyprland, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      utils = import ./conf/utils.nix;

      # A module that loads nur
      nurModule = {
        nixpkgs.config.packageOverrides = pkgs: {
          nur = import nur {
            inherit pkgs;
            nurpkgs = pkgs;
          };
        };
      };

      fullModules = hostname: [
        nurModule

        hyprland.nixosModules.default
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ] ++ (utils.loadBetterModules { inherit hostname system inputs; } [
        ./conf/core.nix
        ./conf/hardware.nix
        ./pkgs/pkgs.nix
        ./conf/user.nix
        ./conf/audio.nix
        ./conf/printing.nix
        ./conf/shell.nix
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
        ./conf/nextcloud.nix
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
        ] ++ utils.loadBetterModules { inherit system inputs; hostname = "nix-live"; } [ ./conf/core.nix ];
      };

      nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = fullModules "arlo-laptop2";
      };

      nixosConfigurations.arlo-nix = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = fullModules "arlo-nix";
      };

      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          nvd
        ];
      };

      templates = {
        empty = {
          path = ./templates/empty;
          description = "An empty flake with a devShell and direnv";
        };
        cpp = {
          path = ./templates/cpp;
          description = "A c++ project using CMake, clang, ccls, and the fmt library";
        };
        pio = {
          path = ./templates/pio;
          description = "A platformio project using C++ 20, ccls, and the fmt library";
        };
        rust = {
          path = ./templates/rust;
          description = "A simple rust project";
        };
      };
    };
}
