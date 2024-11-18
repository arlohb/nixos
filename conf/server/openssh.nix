{ pkgs, ... }:
let
  secrets = import ../../secrets.nix;
in
{
  services.openssh = {
    enable = true;

    ports = [ 81 ];

    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "arlo" ];
      PasswordAuthentication = false;
    };
  };

  users.users.arlo.openssh.authorizedKeys.keys = secrets.ssh.authorizedKeys;

  persist.directories = [
    "/etc/ssh"
  ];
}
