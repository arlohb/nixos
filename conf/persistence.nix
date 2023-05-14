hostname: { ... }:

{
  # Store all persistent files here
  environment.persistence."/nix/persistent" = {
    # Don't show these mounts in file browsers
    # This is because it creates lots of mounts
    hideMounts = true;

    directories = [
      # Nixos config
      "/etc/nixos"
      # Wifi connections
      "/etc/NetworkManager/system-connections"
      # Logs
      "/var/log"
      # Bluetooth
      "/var/lib/bluetooth"
      # Some nixos state
      "/var/lib/nixos"
      # Which users have been lectured by sudo
      "/var/db/sudo"
    ];

    files = [
      # Used by systemd
      "/etc/machine-id"
    ];

    users.root = {
      home = "/root";

      directories = [ ];
      files = [ ];
    };

    users.arlo = {
      directories = [
        # User files
        "code"
        "Vault"
        "3d"
        # Cache
        ".cache"
        # Various program states
        ".local/share/fish"
        ".local/share/nvim"
        ".local/share/Steam"
        ".local/share/PrismLauncher"
        ".local/share/direnv"
        ".local/share/lutris"
        ".local/share/cura"
        ".local/state/nvim"
        ".local/state/wireplumber"
      ] ++ (map (path: ".config/${path}") [
        # Various programs' configuration
        "obsidian"
        "vivaldi"
        "lutris"
        "blender"
        "cura"
      ]);

      files = [ ];
    };
  };
}
