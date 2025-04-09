{ pkgs, ... }:

{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "arlo" ];

  userPersist.directories = [
    ".config/VirtualBox"
  ];
}
