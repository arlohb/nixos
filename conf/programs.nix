{ pkgs, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  pkgs = with pkgs; [
    distrobox

    gparted
    firefox
    obsidian
    porsmo
    insomnia
    spotify

    gnome.gnome-calendar
    gnome.gnome-clocks
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".mozilla"
    ".config/Insomnia"
    ".local/share/containers"
  ];

  # TODO when obsidian updates electron
  # https://github.com/NixOS/nixpkgs/issues/273611
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
