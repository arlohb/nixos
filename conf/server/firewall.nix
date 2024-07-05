{ pkgs, ... }:

{
  # This sets up a firewall that:
  #   - Only allows port 80 and 443
  #   - Only allows traffic to and from the gateway (192.168.1.254),
  #     Including internet access
  #   - Doesn't allow any traffic to devices on the local network
  #   - Places rules on INPUTS, OUTPUT, and DOCKER-USER chains,
  #     To firewall both the host and docker containers

  networking.firewall = {
    allowedTCPPorts = [ 6881 80 443 ];
    allowedUDPPorts = [ 6881 ];
  };

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
}
