lib:
let

  # Get the folders inside a directory
  folders_in_dir = dir:
    lib.attrsets.mapAttrsToList
      (path: type: path)
      (
        lib.attrsets.filterAttrs
          (path: type: type == "directory")
          (builtins.readDir dir)
      );

in builtins.listToAttrs (
  map
    (name:
      {
        inherit name;
        value = {
          path = ./${name};
          description = (import ./${name}/flake.nix).description;
        };
      }
    )
    (folders_in_dir ./.)
)
