{
  description = "AGS configuration.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        buildInputs = with pkgs; [
          bun
          inotify-tools
          nodePackages.typescript-language-server
          vscode-langservers-extracted
        ];
      in {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;
        };

        packages.default = let
          pkgs = nixpkgs.legacyPackages."${system}";

          name = "run-ags";

          src = builtins.readFile ./${name}.sh;
          script = (pkgs.writeScriptBin name src).overrideAttrs(old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
        in pkgs.symlinkJoin {
          name = name;
          paths = [ script ] ++ buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
      }
    );
}
