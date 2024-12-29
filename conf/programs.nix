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

  ] ++ (if (hostname != "arlo-laptop1") then with pkgs; [
    # TODO: Move these and maybe more to another module
    # Might want to have a general look at what's installed on arlo-laptop1
    # (Go totally headless?)
    obsidian
    aseprite
  ] else []);

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
