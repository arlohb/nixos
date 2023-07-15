{ pkgs, ... }@inputs:

{
  pkgs = with pkgs; [
    gparted

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian

    ((import ../pkgs/porsmo.nix) inputs).porsmo

    insomnia
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".config/vivaldi"
    ".config/Insomnia"
  ];
}
