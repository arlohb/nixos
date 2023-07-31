{ pkgs, ... }:

{
  fonts.enableDefaultPackages = true;

  # This is all the stuff I wouldn't need if I used a desktop environment
  pkgs = with pkgs; [
    # For setting backgrounds
    nur.repos.aleksana.swww
    # The top bar and more
    eww-wayland
    # Control media with media keys
    playerctl
    # Image viewer
    feh
    # App launcher
    rofi

    ### Screenshots

    # Captures the screen
    grim
    # Region selection
    slurp
  ];
}
