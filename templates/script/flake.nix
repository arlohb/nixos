{
  description = "Simple shell script as a flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        name = "my_script";

        buildInputs = with pkgs; [
          cowsay
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
