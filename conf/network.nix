{ pkgs, ...}:

let
  secrets = import ../secrets.nix;
in
{
  # Enable mullvad vpn daemon
  services.mullvad-vpn.enable = true;

  pkgs = with pkgs; [
    # TODO: This can be removed
    qbittorrent
  ];

  userPersist.directories = [
    ".config/qBittorrent"
    ".ssh"
  ];

  persist.directories = [
    "/etc/mullvad-vpn"
  ];

  # SSH aliases from secrets.nix
  programs.ssh.extraConfig = secrets.ssh.extraConfig;
}

