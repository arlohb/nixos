{ pkgs, ...}:

{
  # Enable mullvad vpn daemon
  services.mullvad-vpn.enable = true;

  pkgs = with pkgs; [
    qbittorrent
  ];

  userPersist.directories = [
    ".config/qBittorrent"
  ];

  persist.directories = [
    "/etc/mullvad-vpn"
  ];
}

