{ pkgs, config, ... }:
let
  secrets = config.sops.secrets;
in {
  # Creates a Systemd timer to update duckdns with my current IP

  systemd.timers."duckdns" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "10m";
      Unit = "duckdns.service";
    };
  };

  systemd.services."duckdns".serviceConfig = {
    ExecStart = pkgs.writeShellScript "duckdns" ''
      domain="$(cat ${secrets."duckdns/domain".path})"
      token="$(cat ${secrets."duckdns/token".path})"
      echo url="https://www.duckdns.org/update?domains=''${domain}&token=''${token}&ip=" \
        | ${pkgs.curl}/bin/curl -k -o /var/log/duck.log -K -
    '';

    Type = "oneshot";
  };
}
