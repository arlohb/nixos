{ pkgs, ... }:

{
  # Makes the name server 1.1.1.1
  # This breaks resolving hosts on the local network,
  # but that's fine in this case.

  environment.etc."resolv.conf".text = ''
    # If domain has no dots add .home
    search home
    nameserver 1.1.1.1
    # In default
    options edns0
  '';
}
