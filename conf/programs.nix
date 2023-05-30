{ pkgs, ... }:

{
  pkgs = with pkgs; [
    gparted

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
