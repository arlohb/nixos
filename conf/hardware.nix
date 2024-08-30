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
      [ "nvme" "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

    # https://github.com/NixOS/nixpkgs/issues/254807
    swraid.enable = false;
  };

  # Hardware specific options
  hardware.cpu.amd.updateMicrocode = true;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Used to get battery of laptop and other devices
  services.upower.enable = true;

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
    ];
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

    # Nix store on partition labelled "nix"
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };

    # Boot partition on partition labelled "BOOT"
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  } // (if hostname == "arlo-nix" then {
    # Games partition
    "/Steam" = {
      device = "/dev/disk/by-label/steam";
      fsType = "ext4";
    };
  } else if hostname == "arlo-laptop1" then {
    "/mnt" = {
      device = "/dev/sdb1";
      fsType = "ext4";
    };

    "/home/arlo/code/vps/nextcloud_backups" = {
      device = "/mnt/nextcloud_backups";
      options = [ "bind" ];
    };
  } else { });
} // (if hostname == "arlo-nix" then {
  # Only useful on pc, because RAM there only fills up,
  # If something has gone horrifically wrong

  # Kill processes if RAM is nearly full
  # See conf/notifications.nix for more
  services.earlyoom.enable = false;

  # Control screen brightness over HDMI and others
  services.ddccontrol.enable = true;

  # This is set above but would be overridden by the above options
  services.upower.enable = true;

  # I think this thread says my TPM firmware isn't working?
  # This just works around it
  # https://github.com/systemd/systemd/issues/33412#issuecomment-2286210112
  systemd.units."dev-tpmrm0.device".enable = false;
} else if hostname == "arlo-laptop1" || hostname == "arlo-laptop2" then {
  pkgs = with pkgs; [
    # Screen brightness
    brightnessctl
  ];
} else { })
