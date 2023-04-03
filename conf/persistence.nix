{ ... }:

{
  environment.persistence."/nix/persistent" = {
    hideMounts = true;

    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/root/.config/gh"
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
        ".gnupg"
        ".local/share/nvim"
        ".local/state/nvim"
      ] ++ (map (path: ".config/${path}") [
        "gh"
        "obsidian"
        "vivaldi"
      ]);

      files = [
        ".gitconfig"
        ".local/share/fish/fish_history"
      ];
    };
  };
}
