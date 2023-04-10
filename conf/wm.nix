hostname: { pkgs, ... }:

# This is all the stuff I wouldn't need if I used a desktop environment
{
  environment.systemPackages = with pkgs; [
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
