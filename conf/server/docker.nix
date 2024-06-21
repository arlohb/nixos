{ ... }:

{
  virtualisation.docker.enable = true;

  users.users.arlo.extraGroups = [ "docker" ];

  persist.directories = [
    "/var/lib/docker"
  ];
}
