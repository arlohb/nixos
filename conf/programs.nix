{ pkgs, hostname, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  # Uses nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [
      # Just an example
      # "com.ultimaker.cura"
    ];
  };

  # TODO add some synergy like software

  pkgs = with pkgs; [
    distrobox

    gparted
    firefox
    porsmo
    vlc

    gnome-calendar
    gnome-clocks

    obsidian
    aseprite
  ];

  persist.directories = [
    "/var/lib/flatpak"
  ];

  userPersist.directories = [
    ".config/aseprite"
    ".mozilla"
    ".local/share/containers"
    ".local/share/flatpak"
    # Flatpak app data
    ".var"
  ];
}
