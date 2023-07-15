{ pkgs, ... }:

{
  # Distrobox can use podman or docker,
  # I only chose this because I saw somewhere online
  # that podman doesn't require a daemon but docker does.
  virtualisation.podman.enable = true;

  pkgs = with pkgs; [
    distrobox

    gparted
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian
    porsmo
    insomnia
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".config/vivaldi"
    ".config/Insomnia"
    ".local/share/containers"
  ];
}
