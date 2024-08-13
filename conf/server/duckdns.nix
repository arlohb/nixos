{ pkgs, ... }:

{
  # Creates a Systemd timer to update duckdns with my current IP

  systemd.timers."duckdns" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "10m";
      Unit = "duckdns.service";
    };
  };

  systemd.services."duckdns" = {
    script = (with (import ../../secrets.nix).duckDns; ''
      echo url="https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=" \
      | ${pkgs.curl}/bin/curl -k -o /var/log/duck.log -K -
    '');

    serviceConfig.Type = "oneshot";
  };
}
