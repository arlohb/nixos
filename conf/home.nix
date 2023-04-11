{ config, pkgs, ... }:
let
  secrets = import ../secrets.nix;
  cursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
  };
in {
  home = {
    stateVersion = "23.05";

    username = "arlo";
    homeDirectory = "/home/arlo";

    # Link over all files in ../config to ~/.config
    file."${config.xdg.configHome}" = {
      source = ../config;
      recursive = true;
    };

    # Create a git credential file from secrets
    file."${config.xdg.configHome}/git/credentials" = {
      text = secrets.git-credentials;
    };

    # Set x11 cursor
    pointerCursor = cursor;
  };

  # Set gtk cursor
  gtk.cursorTheme = cursor;

  programs = {
    # Setup git
    git = secrets.git // {
      enable = true;

      extraConfig = {
        # Store credentials here
        # This file is created from secrets
        credential.helper = "store --file ~/.config/git/credentials";
        # This is needed for a normal user to control a git repo
        # owned by root, even though it's in the owning group
        safe.directory = "/etc/nixos";
      };
    };

    # Setup the terminal emulator
    kitty = {
      enable = true;

      # Home manager can install this with `font.package`,
      # But I use this everywhere to I can assume it's installed
      font.name = "FiraCode Nerd Font";
      font.size = 10.8;

      # Inbuilt to kitty
      theme = "Dracula";

      settings = {
        # Some ligature settings I prefer
        font_features =
          "FiraCodeNerdFontComplete-Regular +cv01 +ss03 +ss04 +ss08 +cv02";
        disable_ligatures = "never";
        enable_audio_bell = false;
        background_opacity = "0.5";
        confirm_os_window_close = 0;
      };
    };
  };
}
