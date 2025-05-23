{ hostname, ... }:

{
  swapDevices = [
    {
      device = "/nix/var/swap";
      size = if hostname == "arlo-laptop2"
        then 8*1024  # In MB, 64 GB
        else 16*1024; # In MB, 16 GB
    }
  ];
}
