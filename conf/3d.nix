{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    cura
    openscad
  ];

  userPersist.directories = [
    ".local/share/cura"
    ".config/blender"
    ".config/cura"
  ];
}
