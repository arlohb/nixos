{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users.arlo.extraGroups = [ "docker" ];

  persist.directories = [
    "/var/lib/docker"
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  systemd.services.firewall-rules = {
    description = "Post-docker firewall rules";
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = with pkgs; ''${pkgs.writeShellScript "firewall-rules" ''
        counter=0

        # Wait for DOCKER-USER chain to be created
        while ! ${iptables}/bin/iptables -L DOCKER-USER -n; do
          if [[ $counter -gt 10 ]]; then
            echo "Timeout" >&2
            exit 1
          fi

          sleep 1
          counter=$((counter+1))
        done

        # Deny all connection to LAN devices

        # Host to local devices
        ${iptables}/bin/iptables -I OUTPUT -d 192.168.0.0/16 -j DROP
        # Local devices to host
        ${iptables}/bin/iptables -I INPUT -s 192.168.0.0/16 -j DROP
        # Container to local devices
        ${iptables}/bin/iptables -I DOCKER-USER -d 192.168.0.0/16 -j DROP
        # Local devices to container
        ${iptables}/bin/iptables -I DOCKER-USER -s 192.168.0.0/16 -j DROP

        # Allow connection to gateway
        # Input goes through nixos-fw to filter ports

        # Host to gateway
        ${iptables}/bin/iptables -I OUTPUT -d 192.168.1.254 -j ACCEPT
        # Gateway to host
        ${iptables}/bin/iptables -I INPUT -s 192.168.1.254 -j nixos-fw
        # Container to gateway
        ${iptables}/bin/iptables -I DOCKER-USER -d 192.168.1.254 -j ACCEPT
        # Gateway to container
        ${iptables}/bin/iptables -I DOCKER-USER -s 192.168.1.254 -j nixos-fw
      ''}'';
    };
  };

  # DuckDNS
  services.cron = {
    enable = true;

    systemCronJobs = with (import ../secrets.nix).duckDns; [
      "*/5 * * * * ${pkgs.writeShellScriptBin "duck" ''
        echo url="https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=" \
          | curl -k -o /var/log/duck.log -K -
      ''} >/dev/null 2>&1"
    ];
  };

  # Don't sleep when lid is closed
  services.logind.lidSwitch = "ignore";
}
