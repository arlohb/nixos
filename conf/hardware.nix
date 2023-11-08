{ pkgs, config, hostname, ... }:

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
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

    # https://github.com/NixOS/nixpkgs/issues/254807
    swraid.enable = false;
  };

  # Hardware specific options
  hardware.cpu.amd.updateMicrocode = true;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  pkgs =
    if hostname == "arlo-laptop2" then with pkgs; [
      # Screen brightness
      brightnessctl
      
      # Bluetooth gui
      blueberry
    ] else [ ];

  # State
  persist = {
    # Don't show these mounts in file browsers
    # This is because it creates lots of mounts
    hideMounts = true;

    directories = [
      # Nixos config
      "/etc/nixos"
      # Wifi connections
      "/etc/NetworkManager/system-connections"
      # Logs
      "/var/log"
      # Some nixos state
      "/var/lib/nixos"
      # Which users have been lectured by sudo
      "/var/db/sudo"
    ] ++ (if hostname == "arlo-laptop2" then [
      "/var/lib/bluetooth"
    ] else [ ]);
    files = [
      # Used by systemd
      "/etc/machine-id"
    ];
  };

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
  } else { }) // (if hostname == "arlo-laptop2" then {
    # Boot partition
    "/boot" = {
      device = "/dev/disk/by-uuid/58A9-81DF";
      fsType = "vfat";
    };
  } else { });
}
