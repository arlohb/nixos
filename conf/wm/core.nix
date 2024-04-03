{ pkgs, inputs, ... }:

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

    ### Screenshots

    # Captures the screen
    grim
    # Region selection
    slurp
  ];

  # Widgets
  hm.imports = [ inputs.ags.homeManagerModules.default ];
  hm.programs.ags = {
    enable = true;
    configDir = ./ags;
  };
}
