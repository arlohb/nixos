hostname: { config, pkgs, ... }:

{
  # Boot options
  boot = {
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    # Hardware specific options
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # Hardware specific options
  hardware.cpu.amd.updateMicrocode = true;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Mounts
  fileSystems = {
    # Root filesystem is stored in ram
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "noatime" "mode=755" ];
      neededForBoot = true;
    };

    # Nix store on partition labelled 'nix'
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
  } // (if hostname == "arlo-nix" then {
    # Boot partition
    "/boot" = {
      device = "/dev/disk/by-uuid/C16B-77F7";
      fsType = "vfat";
    };

    # Games partition
    "/Steam" = {
      device = "/dev/disk/by-label/steam";
      fsType = "ext4";
    };
  } else {}) // (if hostname == "arlo-laptop2" then {
    # Boot partition
    "/boot" = {
      device = "/dev/disk/by-uuid/58A9-81DF";
      fsType = "vfat";
    };
  } else {});
}
