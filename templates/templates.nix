lib: builtins.listToAttrs (
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
    ((import ../utils.nix lib).folders_in_dir ./.)
)
