{ pkgs, inputs, hostname, system, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      roboto
    ];

    fontconfig.defaultFonts = {
      serif = [ "roboto" ];
      sansSerif = [ "roboto" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  # This is all the stuff I wouldn't need if I used a desktop environment
  pkgs = with pkgs; [
    # For setting backgrounds
    swww
    # The top bar and more
    eww
    # Control media with media keys
    playerctl
    # Image viewer
    feh
    # App launcher
    rofi
    # GTK icons
    adwaita-icon-theme

    ### Screenshots

    # Captures the screen
    grim
    # Region selection
    slurp

    # Colour picker
    hyprpicker

    # My AGS bar
    inputs.bar.packages."${system}".default
  ] ++ (if hostname == "arlo-laptop2"
    then [
      inputs.wl_keys.packages."${system}".default
    ]
    else []);
}
