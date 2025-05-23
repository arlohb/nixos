# TODO: This is incomplete and doesn't work
{ ... }:
let
  secrets = (import ../secrets.nix).wg;
  port = 51820;
in {
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.192.1.2/24" ];
    # listenPort = port;
    privateKey = secrets.myPrivateKey;
    dns = [ "10.0.0.185" ];

    peers = [
      {
        publicKey = secrets.serverPublicKey;
        presharedKey = secrets.presharedKey;
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "arlodev.co.uk:${toString port}";
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ port ];
}
