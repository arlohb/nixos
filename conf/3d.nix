{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    openscad
    freecad-wayland
    kicad
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
    ".config/kicad"
    ".local/share/kicad"
  ];
}
