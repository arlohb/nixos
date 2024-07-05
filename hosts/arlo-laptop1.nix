# TODO: Make these configurable NixOS modules
[
  # Core
  ../conf/core.nix
  ../conf/hardware.nix
  ../conf/user.nix
  ../conf/shell.nix
  ../conf/audio.nix

  # Desktop
  ../conf/wm/core.nix
  ../conf/wm/cursor.nix
  ../conf/wm/login.nix
  ../conf/wm/notifications.nix
  ../conf/wm/polkit.nix
  ../conf/wm/hypr/hypr.nix

  # Programs
  ../conf/git.nix
  ../conf/neovim.nix
  ../conf/network.nix
  ../conf/programs.nix
  ../conf/terminal.nix

  # Server
  ../conf/server/core.nix
  ../conf/server/cloudflare-dns.nix
  ../conf/server/docker.nix
  ../conf/server/duckdns.nix
  ../conf/server/firewall.nix
]
