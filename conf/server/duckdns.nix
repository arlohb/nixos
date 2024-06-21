{ pkgs, ... }:

{
  # Creates a Cron Job to update duckdns with my current IP

  services.cron = {
    enable = true;

    systemCronJobs = with (import ../../secrets.nix).duckDns; [
      # This runs every 5 minutes
      "*/5 * * * * ${pkgs.writeShellScriptBin "duck" ''
        echo url="https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=" \
          | curl -k -o /var/log/duck.log -K -
      ''} >/dev/null 2>&1"
    ];
  };
}
