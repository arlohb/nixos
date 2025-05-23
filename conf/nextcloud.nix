{ pkgs, hostname, config, ... }:

let
  secrets = config.sops.secrets;
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
      ${pkgs.sqlite}/bin/sqlite3 ~/Nextcloud/.*.db "PRAGMA journal_mode = delete;"

      user=$(cat ${secrets."nextcloud/user".path})
      password=$(cat ${secrets."nextcloud/password".path})
      server=$(cat ${secrets."nextcloud/server".path})

      ${pkgs.nextcloud-client}/bin/nextcloudcmd \
        --user $user \
        --password $password \
        --unsyncedfolders ${pkgs.writeText "NextCloudNoSync.txt" ''
          Media/Audiobooks
          Media/Books
          Media/Movies
          Media/Shows
          Photos
          Backups
        ''} \
        ~/Nextcloud $server
    '';
  };
}
