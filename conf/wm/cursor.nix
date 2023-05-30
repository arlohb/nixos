{ pkgs, ... }:

let
  cursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
  };
in
{
  # Set x11 cursor
  hm.home.pointerCursor = cursor;

  # Set gtk cursor
  hm.gtk.cursorTheme = cursor;
}
