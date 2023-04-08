# This is built with:
# nix build .#nixosConfigurations.live.config.system.build.isoImage
{ pkgs, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
}
