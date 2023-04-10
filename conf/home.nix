{ config, pkgs, lib, ... }:
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

    /* file = builtins.listToAttrs (map */
    /*   (file: if lib.strings.hasPrefix "[" (builtins.baseNameOf file) */
    /*     then {} */
    /*     else { */
    /*       /1* name = "${config.xdg.configHome}/${lib.strings.removePrefix "/etc/nixos/config/" (builtins.toString file)}"; *1/ */
    /*       name = "${config.xdg.configHome}/${builtins.toString file}"; */
    /*       /1* name = "${config.xdg.configHome}/${builtins.baseNameOf file}"; *1/ */
    /*       value.source = file; */
    /*     } */
    /*   ) */
    /*   (lib.filesystem.listFilesRecursive ../config)); */

    file."${config.xdg.configHome}" = {
      source = ../config;
      recursive = true;
    };

    pointerCursor = cursor;
  };

  gtk.cursorTheme = cursor;

  programs = {
    git = secrets.git // {
      enable = true;

      extraConfig = {
        credential.helper = "store";
        safe.directory = "/etc/nixos";
      };
    };

    kitty = {
      enable = true;

      # Home manager can install this with `font.package`,
      # But I use this everywhere to I can assume it's installed
      font.name = "FiraCode Nerd Font";
      font.size = 10.8;

      theme = "Dracula";

      settings = {
        font_features =
          "FiraCodeNerdFontComplete-Regular +cv01 +ss03 +ss04 +ss08 +cv02";
        disable_ligatures = "never";
        enable_audio_bell = false;
        background_opacity = "0.5";
        confirm_os_window_close = 0;
      };
    };
  };

  imports = [ ./neovim/neovim.nix ];
}
