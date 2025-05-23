{ config, ... }:

{
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://datasphere.lan:6443";
    tokenFile = config.sops.secrets.k3s-token.path;
  };

  persist.directories = [
    "/etc/rancher"
    "/var/lib/rancher/k3s"
  ];
}
