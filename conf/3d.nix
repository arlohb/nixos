{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    openscad
    freecad-wayland
  ];

  services.flatpak.packages = [
    "com.ultimaker.cura"
  ];

  userPersist.directories = [
    ".local/share/cura"
    ".config/blender"
    ".config/cura"
    ".config/FreeCAD"
    ".local/share/FreeCAD"
  ];
}
