{ pkgs, ... }:

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

    # TODO: Move these to another module
    # As these are being installed on arlo-laptop1
    # Might want to have a general look at what's installed on arlo-laptop1
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
