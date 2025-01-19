{ pkgs, ... }:
let
  shares = builtins.map
    (share: {
      IPs = [ "10.0.0.0/24" ];
      allowRoot = false;
    } // share)
    [
      # Docker Volumes

      {
        exportPath = "/export/volumes/nodered";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/nodered";
      }
      {
        exportPath = "/export/volumes/wireguard";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/wireguard";
      }
      {
        exportPath = "/export/volumes/qbt/config";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/qbt/config";
      }
      {
        exportPath = "/export/volumes/qbt/downloads";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/qbt/downloads";
      }
      {
        exportPath = "/export/volumes/prowlarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/prowlarr";
      }
      {
        exportPath = "/export/volumes/radarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/radarr";
      }
      {
        exportPath = "/export/volumes/sonarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/sonarr";
      }
      {
        exportPath = "/export/volumes/readarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/readarr";
      }
      {
        exportPath = "/export/volumes/jellyseerr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/jellyseerr";
        allowRoot = true;
      }
      {
        exportPath = "/export/volumes/kiwix";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/kiwix";
      }

      # Media

      {
        exportPath = "/export/media/movies";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Movies";
      }
      {
        exportPath = "/export/media/shows";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Shows";
      }
      {
        exportPath = "/export/media/books/audiobooks";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Books/Audiobooks";
      }
      {
        exportPath = "/export/media/books/books";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Books/Books";
      }
    ];
in {
  fileSystems = builtins.listToAttrs (
    builtins.map
      (share: {
        name = share.exportPath;
        value = {
          device = share.srcPath;
          options = [ "bind" ];
        };
      })
      shares
  );

  services.nfs.server = {
    enable = true;

    exports = pkgs.lib.strings.concatMapStrings
      (share: let
        rootSquashOption = if share.allowRoot then ",no_root_squash" else "";
        hosts = pkgs.lib.strings.concatMapStrings
          (ip: " ${ip}(rw,sync${rootSquashOption})")
          share.IPs;
      in
        "${share.exportPath}${hosts}\n"
      )
      shares;
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
