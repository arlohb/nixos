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

    # nix-index prebuilt database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # My neovim config made with nixvim
    nixvim.url = "github:arlohb/nvim";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    # An on-screen keyboard
    wl_keys.url = "github:arlohb/wl_keys";
    wl_keys.inputs.nixpkgs.follows = "nixpkgs";

    # A simple timer.
    # I don't use this, and it's now in nixpkgs
    # But I'll leave it so I know how to add my own pkgs
    porsmo.url = "github:ColorCookie-dev/porsmo?rev=37528c9c4421c5be853a0509812c23ec60c3eca1";
    porsmo.flake = false;

    # A PR that fixes scrolling
    lan-mouse.url = "github:feschber/lan-mouse/pull/240/head";
    lan-mouse.inputs.nixpkgs.follows = "nixpkgs";

    kmonad.url = "github:kmonad/kmonad?dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";

    presenterm.url = "github:mfontanini/presenterm";

    scripts.url = "github:arlohb/scripts";
    scripts.inputs.nixpkgs.follows = "nixpkgs";

    bar.url = "github:arlohb/bar";
  };

  outputs = { self, nixpkgs, home-manager, impermanence, nix-index-database, nixvim, nix-flatpak, scripts, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      utils = import ./utils.nix nixpkgs.lib;

      lan-mouse-fix = {
        nixpkgs.config.packageOverrides = pkgs: {
          lan-mouse = inputs.lan-mouse.packages."${system}".default;
          presenterm = inputs.presenterm.packages."${system}".default;
        };
      };

      fullModules = [
        impermanence.nixosModules.impermanence
        {
          # Impermanence has a temporary issue
          # https://github.com/nix-community/impermanence/issues/229
          boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
          systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
        }

        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        inputs.kmonad.nixosModules.default

        lan-mouse-fix

        {
          home-manager.useGlobalPkgs = true;
          environment.systemPackages = pkgs.lib.attrValues scripts.packages.${system};
        }

        {
          imports = [
            ./conf/aliases.nix
          ];

          aliases.enable = true;
        }
      ];
    in
    {
      nixosConfigurations = let
        buildHost = hostname:
          nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = { inherit hostname system inputs; };
            modules = fullModules ++ [{
              imports = [
                ./hosts/${hostname}.nix
              ];
            }];
          };
      in {
        # Build this with:
        # nix build .#nixosConfigurations.live.config.system.build.isoImage
        nix-live = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit system inputs; hostname = "nix-live"; };
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            ./conf/core.nix
          ];
        };

        arlo-laptop1 = buildHost "arlo-laptop1";
        arlo-laptop2 = buildHost "arlo-laptop2";
        arlo-nix = buildHost "arlo-nix";
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
