{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manages persistant files when / is a tmpfs
    impermanence.url = "github:nix-community/impermanence";

    # A nvim plugin not (yet) in nixpkgs
    drop-nvim.url = "github:folke/drop.nvim";
    drop-nvim.flake = false;
    vim-nand2tetris-syntax.url = "github:sevko/vim-nand2tetris-syntax";
    vim-nand2tetris-syntax.flake = false;

    # A simple timer.
    # I don't use this, and it's now in nixpkgs
    # But I'll leave it so I know how to add my own pkgs
    porsmo.url = "github:ColorCookie-dev/porsmo?rev=37528c9c4421c5be853a0509812c23ec60c3eca1";
    porsmo.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      utils = import ./utils.nix;

      fullModules = hostname: [
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
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
        ./conf/wm/notifications.nix
        ./conf/wm/polkit.nix
        ./conf/wm/login.nix
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

      templates = import ./templates/templates.nix nixpkgs.lib;
    };
}
