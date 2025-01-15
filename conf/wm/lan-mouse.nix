{ pkgs, hostname, ... }:
{
  pkgs = with pkgs; [
    lan-mouse
  ];

  networking.firewall.allowedTCPPorts = [ 4242 ];
  networking.firewall.allowedUDPPorts = [ 4242 ];

  userPersist.directories = [
    ".config/lan-mouse"
  ];
}
