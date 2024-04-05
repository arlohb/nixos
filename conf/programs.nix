{ pkgs, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  # TODO add some synergy like software

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

    eclipses.eclipse-java
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".mozilla"
    ".config/Insomnia"
    ".local/share/containers"
    ".config/eclipse-workspace"
  ];
}
