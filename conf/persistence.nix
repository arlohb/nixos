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

      directories = [
        ".config/gh"
      ];
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
      ] ++ (map (path: ".config/${path}") [
        "gh"
        "obsidian"
        "vivaldi"
      ]);

      files = [];
    };
  };
}
