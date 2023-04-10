hostname: { ... }:

{
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "noatime" "mode=755" ];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
  } // (if hostname == "arlo-nix" then {
    "/boot" = {
      device = "/dev/disk/by-uuid/C16B-77F7";
      fsType = "vfat";
    };

    "/Steam" = {
      device = "/dev/disk/by-label/steam";
      fsType = "ext4";
    };
  } else {}) // (if hostname == "arlo-laptop2" then {
    "/boot" = {
      device = "/dev/disk/by-uuid/58A9-81DF";
      fsType = "vfat";
    };
  } else {});
}
