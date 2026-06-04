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
    inputs.awww.packages."${system}".default
    # The top bar and more
    eww
    # Control media with media keys
    playerctl
    # Image viewer
    feh
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

  hm.programs.rofi = {
    enable = true;
    extraConfig = {
      # https://www.reddit.com/r/i3wm/comments/ebf9t8/rofi_single_click_accept/
      # 

      # Highlight an entry under the mouse pointer
      hover-select = true;

      # Disable MousePrimary as an entry selector
      # Without this setting you won't be able to set MousePrimary as an entry acceptor
      me-select-entry = "";

      # Use either LMB single click or RMB single click or LMB double click to accept an entry
      me-accept-entry = [ "MousePrimary" "MouseSecondary" "MouseDPrimary" ];
    };
  };
}
