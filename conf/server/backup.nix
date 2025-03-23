{ pkgs, ... }:
let
  secrets = import ../../secrets.nix;
in
{
  pkgs = with pkgs; [
    btrfs-progs
    borgbackup
  ];

  # Mount backup drive
  fileSystems."/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail"                        # Don't fail to boot if not present
      "x-system.device-timeout=10"    # Give up faster if not present
      # "compress-force=zstd:15"      # BorgBackup does compression for us
    ];
  };

  # Setup backup user and group
  users = {
    groups.backup.gid = 899;
    users.backup = {
      uid = 899;
      isSystemUser = true;
      shell = "/bin/sh";
      group = "backup";

      openssh.authorizedKeys.keys = secrets.ssh.backupAuthorizedKeys;
    };
  };

  # Setup backup user ssh
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "backup" ];
    };
  };
}
