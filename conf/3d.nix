{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    cura
  ];

  userPersist.directories = [
    ".local/share/cura"
    ".config/blender"
    ".config/cura"
  ];
}
