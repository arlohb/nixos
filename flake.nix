{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manages persistent files when / is a tmpfs
    impermanence.url = "github:nix-community/impermanence";

    # My neovim config made with nixvim
    nixvim.url = "github:arlohb/nvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # An on-screen keyboard
    wl_keys.url = "github:arlohb/wl_keys";
    wl_keys.inputs.nixpkgs.follows = "nixpkgs";

    # A simple timer.
    # I don't use this, and it's now in nixpkgs
    # But I'll leave it so I know how to add my own pkgs
    porsmo.url = "github:ColorCookie-dev/porsmo?rev=37528c9c4421c5be853a0509812c23ec60c3eca1";
    porsmo.flake = false;

    scripts.url = "github:arlohb/scripts";
    scripts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, impermanence, nixvim, scripts, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      utils = import ./utils.nix nixpkgs.lib;

      fullModules = hostname: modulePaths: [
        impermanence.nixosModules.impermanence
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          environment.systemPackages = pkgs.lib.attrValues scripts.packages.${system};
        }
      ] ++ (utils.loadBetterModules
        { inherit hostname system inputs; }
        modulePaths
      );
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

      nixosConfigurations.arlo-laptop1 = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = fullModules "arlo-laptop1" [
          # TODO: Put these into separate device files
          # TODO: Make these configurable NixOS modules
          ./conf/core.nix
          ./conf/hardware.nix

          # ./conf/3d.nix
          # ./conf/android-studio.nix
          # ./conf/audio.nix
          # ./conf/bluetooth.nix
          # ./conf/gaming.nix
          ./conf/git.nix
          ./conf/neovim.nix
          # ./conf/network.nix
          # ./conf/nextcloud.nix
          # ./conf/printing.nix
          ./conf/programs.nix
          ./conf/shell.nix
          ./conf/terminal.nix
          ./conf/user.nix

          ./conf/wm/core.nix
          ./conf/wm/cursor.nix
          ./conf/wm/login.nix
          ./conf/wm/notifications.nix
          ./conf/wm/polkit.nix
          ./conf/wm/hypr/hypr.nix

          # ./pkgs/pkgs.nix
        ];
      };

      nixosConfigurations.arlo-laptop2 = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = fullModules "arlo-laptop2" [
          ./conf/core.nix
          ./conf/hardware.nix

          ./conf/3d.nix
          # ./conf/android-studio.nix
          ./conf/audio.nix
          ./conf/bluetooth.nix
          ./conf/gaming.nix
          ./conf/git.nix
          ./conf/neovim.nix
          ./conf/network.nix
          ./conf/nextcloud.nix
          ./conf/printing.nix
          ./conf/programs.nix
          ./conf/shell.nix
          ./conf/terminal.nix
          ./conf/user.nix

          ./conf/wm/core.nix
          ./conf/wm/cursor.nix
          ./conf/wm/login.nix
          ./conf/wm/notifications.nix
          ./conf/wm/polkit.nix
          ./conf/wm/hypr/hypr.nix

          ./pkgs/pkgs.nix
        ];
      };

      nixosConfigurations.arlo-nix = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = fullModules "arlo-nix" [
          ./conf/core.nix
          ./conf/hardware.nix

          ./conf/3d.nix
          # ./conf/android-studio.nix
          ./conf/audio.nix
          ./conf/bluetooth.nix
          ./conf/gaming.nix
          ./conf/git.nix
          ./conf/neovim.nix
          ./conf/network.nix
          ./conf/nextcloud.nix
          ./conf/printing.nix
          ./conf/programs.nix
          ./conf/shell.nix
          ./conf/terminal.nix
          ./conf/user.nix

          ./conf/wm/core.nix
          ./conf/wm/cursor.nix
          ./conf/wm/login.nix
          ./conf/wm/notifications.nix
          ./conf/wm/polkit.nix
          ./conf/wm/hypr/hypr.nix

          ./pkgs/pkgs.nix
        ];
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
