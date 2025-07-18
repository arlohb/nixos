{ ... }:
{
  imports = [
    # Core
    ../conf/sops.nix
    ../conf/core.nix
    ../conf/hardware.nix
    ../conf/user.nix
    ../conf/shell.nix

    # Programs
    ../conf/git.nix
    ../conf/neovim.nix
    ../conf/network.nix

    # Server
    ../conf/server/core.nix
    ../conf/server/docker.nix
    ../conf/server/duckdns.nix
    ../conf/server/openssh.nix
    ../conf/server/backup.nix
    ../conf/server/k3s-agent.nix
    ../conf/server/transcode.nix
    ../conf/server/nas-mount.nix
  ];
}
