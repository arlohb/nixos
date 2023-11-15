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

  systemd.timers."nextcloud-sync" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "2m";
      Unit = "nextcloud-sync.service";
    };
  };

  systemd.services."nextcloud-sync" = {
    # This is a real issue, that's been closed without being fixed, so may never be fixed.
    # It *may* be related to ~/Nextcloud being a bind mount or something, but who knows.
    # https://github.com/nextcloud/desktop/issues/3840
    # For now this 'fix' works
    # https://github.com/nextcloud/desktop/issues/3840#issuecomment-1356843834
    script = ''
      ${pkgs.sqlite}/bin/sqlite3 ~/Nextcloud/.*.db "PRAGMA journal_mode = delete;"

      ${pkgs.nextcloud-client}/bin/nextcloudcmd \
        --user ${secrets.nextcloud.user} \
        --password ${secrets.nextcloud.password} \
        --unsyncedfolders ${pkgs.writeText "NextCloudNoSync.txt" ''
        ''} \
        ~/Nextcloud ${secrets.nextcloud.server}
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "arlo";
    };
  };
}
