{ pkgs, ... }:

{
  pkgs = with pkgs; [
    blender
    # TODO: Add cura to nix-flatpak and remove note here
    # https://github.com/NixOS/nixpkgs/issues/186570
    # Best to use flatpak until this is fixed
    # cura
    openscad
  ];

  userPersist.directories = [
    ".local/share/cura"
    ".config/blender"
    ".config/cura"
  ];
}
