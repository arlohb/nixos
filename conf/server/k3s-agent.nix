{ ... }:
let
  secrets = import ../../secrets.nix;
in
{
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://datasphere.lan:6443";
    token = secrets.k3s.token;
  };

  persist.directories = [
    "/etc/rancher"
    "/var/lib/rancher/k3s"
  ];
}
