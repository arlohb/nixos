{ pkgs, config, hostname, ... }:

let
  cursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
  };
in
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    nvidiaPatches = false;
    xwayland.hidpi = false;
  };

  # Add hostname specific config for hyprland
  hm.home.file."/home/arlo/.config/hypr/monitors.conf" = {
    source =
      if hostname == "arlo-nix" then
        ../config/hypr/maybe/arlo-nix.conf
      else
        ../config/hypr/maybe/arlo-laptop2.conf;
  };

  # This is all the stuff I wouldn't need if I used a desktop environment
  pkgs = with pkgs; [
    libnotify # For testing configs
    nur.repos.aleksana.swww # For setting backgrounds
    eww-wayland # The top bar and more
    xorg.xhost # Used to disable xorg / xwayland access control
    dwt1-shell-color-scripts # Ran on shell start
    playerctl # Control media with media keys

    # Screenshots
    grim # Captures the screen
    slurp # Region selection

    # Polkit
    polkit_gnome
  ];

  # Set x11 cursor
  hm.home.pointerCursor = cursor;

  # Set gtk cursor
  hm.gtk.cursorTheme = cursor;

  # Polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
