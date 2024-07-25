{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    openscad
  ];

  services.flatpak.packages = [
    "com.ultimaker.cura"
  ];

  userPersist.directories = [
    ".local/share/cura"
    ".config/blender"
    ".config/cura"
  ];
}
