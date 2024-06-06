{ pkgs, hostname, ... }:

let
  secrets = import ../secrets.nix;
in
{
  pkgs = with pkgs; [
    nextcloud-client
  ];

  userPersist.directories = [
    "Nextcloud"
  ] ++ (if hostname == "arlo-laptop2" then [
    # TODO: Make automatic every week or something
    "NextcloudBackup"
  ] else [ ]);

  # Couldn't change timer to above the time here with change_timer
  # So I'll set this to the max and reduce with exec-once in hyprland
  hm.systemd.user.timers."nextcloud-sync" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      OnBootSec = "10m";
      OnUnitActiveSec = "10m";
      Unit = "nextcloud-sync.service";
    };
  };

  hm.systemd.user.services."nextcloud-sync" = {
    Unit.Description = "Sync ~/Nextcloud to Nextcloud server";

    # This is a real issue, that's been closed without being fixed, so may never be fixed.
    # It *may* be related to ~/Nextcloud being a bind mount or something, but who knows.
    # https://github.com/nextcloud/desktop/issues/3840
    # For now this 'fix' works
    # https://github.com/nextcloud/desktop/issues/3840#issuecomment-1356843834
    Service.ExecStart = pkgs.writeShellScript "nextcloud-sync" ''
      #!/usr/bin/env bash

      ${pkgs.sqlite}/bin/sqlite3 ~/Nextcloud/.*.db "PRAGMA journal_mode = delete;"

      ${pkgs.nextcloud-client}/bin/nextcloudcmd \
        --user ${secrets.nextcloud.user} \
        --password ${secrets.nextcloud.password} \
        --unsyncedfolders ${pkgs.writeText "NextCloudNoSync.txt" ''
        ''} \
        ~/Nextcloud ${secrets.nextcloud.server}
    '';
  };
} // (if hostname == "arlo-nix"
  then {
    # Move the media folder to a bigger, slower drive
    fileSystems."/home/arlo/Nextcloud/Media" = {
      device = "/Steam/Media";
      options = [ "bind" ];
    };
  }
  else {})
