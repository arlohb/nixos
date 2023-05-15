{ pkgs, ... }:

{
  pkgs = with pkgs; [
    # Basic programs
    neofetch # Pretty
    feh # Image viewer
    rofi # App launcher
    gparted # Disk manager

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".config/vivaldi"
  ];
}
