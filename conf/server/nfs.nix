{ pkgs, ... }:
let
  shares = builtins.map
    (share: {
      allowRoot = false;
    } // share)
    [
      # Docker Volumes

      {
        exportPath = "/export/volumes/nodered";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/nodered";
        IPs = [ "10.0.0.220" ];
      }
      {
        exportPath = "/export/volumes/wireguard";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/wireguard";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/qbt/config";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/qbt/config";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/qbt/downloads";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/qbt/downloads";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/prowlarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/prowlarr";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/radarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/radarr";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/sonarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/sonarr";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/readarr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/readarr";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/volumes/jellyseerr";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/jellyseerr";
        IPs = [ "10.0.0.154" ];
        allowRoot = true;
      }
      {
        exportPath = "/export/volumes/kiwix";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/kiwix";
        IPs = [ "10.0.0.220" ];
      }

      # Media

      {
        exportPath = "/export/media/movies";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Movies";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/media/shows";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Shows";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/media/books/audiobooks";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Books/Audiobooks";
        IPs = [ "10.0.0.154" ];
      }
      {
        exportPath = "/export/media/books/books";
        srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Media/Books/Books";
        IPs = [ "10.0.0.154" ];
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
