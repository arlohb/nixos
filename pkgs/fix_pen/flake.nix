{
  description = "Simple script to map libinput stylus touches to wayland events";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }: let
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        name = "fix_pen";

        buildInputs = with pkgs; [
          libinput ydotool
        ];

        src = builtins.readFile ./${name}.sh;
        script = (pkgs.writeScriptBin name src).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
      in {
        packages = rec {
          ${name} = pkgs.symlinkJoin {
            name = name;
            paths = [ script ] ++ buildInputs;
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
          };

          default = self.packages.${system}.${name};
        };
      }
    );
}
