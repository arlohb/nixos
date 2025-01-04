{ pkgs, ... }:

{
  fileSystems."/export/volumes/jellyseerr" = {
    device = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/jellyseerr";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    # no_root_squash means root can access the files on the client
    # Useful when debugging, but not needed with docker compose
    exports = ''
      /export/volumes/jellyseerr  10.0.0.220(rw,sync)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
