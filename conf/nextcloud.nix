{ pkgs, ... }:

let
  secrets = import ../secrets.nix;
in
{
  pkgs = with pkgs; [
    nextcloud-client
  ];

  userPersist.directories = [
    "Nextcloud"
  ];

  hm.systemd.user.timers."nextcloud-sync" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      OnBootSec = "2m";
      OnUnitActiveSec = "2m";
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
}
