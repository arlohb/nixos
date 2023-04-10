hostname: { ... }:

{
  environment.persistence."/nix/persistent" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.root = {
      home = "/root";

      directories = [];
      files = [];
    };

    users.arlo = {
      directories = [
        "code"
        "Vault"
        ".cache"
        ".ssh"
        ".local/share/fish"
        ".local/share/nvim"
        ".local/share/Steam"
        ".local/state/nvim"
        ".local/state/wireplumber"
      ] ++ (map (path: ".config/${path}") [
        "obsidian"
        "vivaldi"
      ]);

      files = [];
    };
  };
}
