{ ... }:

{
  swapDevices = [
    {
      device = "/nix/var/swap";
      size = 16*1024; # In MB, 16 GB
    }
  ];
}
