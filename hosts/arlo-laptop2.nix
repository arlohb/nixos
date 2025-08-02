{ ... }:
{
  imports = [
    # Core
    ../conf/sops.nix
    ../conf/core.nix
    ../conf/swap.nix
    ../conf/hardware.nix
    ../conf/user.nix
    ../conf/shell.nix
    ../conf/audio.nix
    ../conf/bluetooth.nix

    # Desktop
    ../conf/wm/core.nix
    ../conf/wm/cursor.nix
    ../conf/wm/login.nix
    ../conf/wm/notifications.nix
    ../conf/wm/polkit.nix
    ../conf/wm/hypr/hypr.nix
    ../conf/wm/lan-mouse.nix
    ../conf/wm/kbd/kmonad.nix

    # Programs
    ../conf/3d.nix
    ../conf/gaming.nix
    ../conf/git.nix
    ../conf/neovim.nix
    ../conf/network.nix
    ../conf/nextcloud.nix
    ../conf/printing.nix
    ../conf/programs.nix
    ../conf/terminal.nix
    ../conf/idea.nix
    ../conf/unity.nix
    ../conf/server/docker.nix
  ];
}
