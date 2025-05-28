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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
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
    presenterm
    aseprite
    teams-for-linux
  ];

  persist.directories = [
    "/var/lib/flatpak"
  ];

  userPersist.directories = [
    ".config/aseprite"
    ".mozilla"
    ".config/teams-for-linux"
    ".local/share/containers"
    ".local/share/flatpak"
    # Flatpak app data
    ".var"
  ];
}
