{
  description = "A rust bevy project.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        name = "name";
        version = "0.0.1";
        deps = with pkgs; [
          # Bevy Nix dependencies
          # https://github.com/bevyengine/bevy/blob/latest/docs/linux_dependencies.md#nix
          pkg-config
          udev
          alsa-lib
          vulkan-loader
          # Wayland
          libxkbcommon
          wayland
        ];

        package = pkgs.rustPlatform.buildRustPackage {
          inherit version;
          pname = name;

          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          nativeBuildInputs = deps;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            rust-analyzer
            clippy
            rustfmt
          ] ++ deps;

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath deps;
        };

        packages = rec {
          "${name}" = package;
          default = package;
        };
      }
    );
}
