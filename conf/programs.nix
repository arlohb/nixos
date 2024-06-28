{ pkgs, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  # TODO: Look at nix-flatpak
  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;

  # TODO add some synergy like software

  pkgs = with pkgs; [
    distrobox

    gparted
    firefox
    obsidian
    porsmo

    gnome.gnome-calendar
    gnome.gnome-clocks
  ];

  persist.directories = [
    "/var/lib/flatpak"
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".mozilla"
    ".local/share/containers"
    ".local/share/flatpak"
  ];
}
