{ pkgs, ... }:

{
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    # Oddly enough the port for this conflicts with the Logic World game server port
    ipv6 = false;
  };
}
