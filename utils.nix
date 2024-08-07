lib: rec {
  # Lots of very common options are very long,
  # So I've remapped them to shorter names:
  #   - environment.systemPackages                           -> pkgs
  #   - environment.persistence."/nix/persistent"            -> persist
  #   - environment.persistence."/nix/persistent".users.arlo -> userPersist
  #   - home-manager.users.arlo                              -> hm
  betterModule =
    # The actual module
    module:
    # The usual nixos module inputs
    moduleInputs:
    let
      origin = module (moduleInputs);

      pkgs = origin.pkgs or [ ];
      persist = origin.persist or { };
      userPersist = origin.userPersist or { };
      hm = origin.hm or { };

      final = builtins.removeAttrs origin [
        "pkgs"
        "persist"
        "userPersist"
        "hm"
      ];
    in
    final
    // {
      environment = {
        persistence."/nix/persistent" = persist // {
          users.arlo = userPersist;
        };

        systemPackages = pkgs;
      } // final.environment or { };

      home-manager.users.arlo = hm;
    };

  # This runs the betterModule function on a list of module paths.
  # The purporse of this is the add in the moduleInputs.
  #
  # This is harder than it should be, as I have to destructor them,
  # even if I don't use them.
  # I believe this is so NixOS knows which module inputs to provide to the module,
  # as even in a completely lazy language, all the module inputs may be too much?
  loadBetterModules = map (
    path:
    { pkgs, config, lib, ... }@moduleInputs:
    betterModule (import path) moduleInputs
  );

  # Get the folders inside a directory
  folders_in_dir = dir:
    lib.attrsets.mapAttrsToList
      (path: type: path)
      (
        lib.attrsets.filterAttrs
          (path: type: type == "directory")
          (builtins.readDir dir)
      );

  # Get the files inside a directory
  files_in_dir = dir:
    lib.attrsets.mapAttrsToList
      (path: type: path)
      (
        lib.attrsets.filterAttrs
          (path: type: type == "regular")
          (builtins.readDir dir)
      );

  # Add the file name to the end of a path and return as a path
  prepend_path = path: name: path + ("/" + name);

  # Like folders_in_dir but returns paths
  folder_paths_in_dir = dir: map (prepend_path dir) (files_in_dir dir);

  # Like files_in_dir but returns paths
  file_paths_in_dir = dir: map (prepend_path dir) (files_in_dir dir);
}
