{ pkgs, ...}:

let
  secrets = import ../secrets.nix;
in
{
  # Enable mullvad vpn daemon
  services.mullvad-vpn.enable = true;

  userPersist.directories = [
    ".ssh"
  ];

  persist.directories = [
    "/etc/mullvad-vpn"
  ];

  # SSH aliases from secrets.nix
  programs.ssh.extraConfig = secrets.ssh.extraConfig;
}

