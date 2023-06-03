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
  ];

  userPersist.directories = [
    ".config/obsidian"
    ".config/vivaldi"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];
}
