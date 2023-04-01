{ ... }:

{
  environment.persistence."/nix/persistent" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/home"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
    ];

    files = [
      "/root/.gitconfig"
      "/etc/machine-id"
    ];

    users.arlo = {
      directories = [
        "code"
        "Vault"
        ".cache"
        ".local"
        ".gnupg"
      ];

      files = [
        ".gitconfig"
      ];
    };
  };
}
