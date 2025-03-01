{ pkgs, ... }:
let
  shares = builtins.map
    (share: {
      IPs = [ "10.0.0.0/24" ];
      allowRoot = false;
    } // share)
    [
      # e.g.
      # {
      #   exportPath = "/export/volumes/nodered";
      #   srcPath = "/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/admin/files/Volumes/nodered";
      # }
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
