lib: rec {
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
