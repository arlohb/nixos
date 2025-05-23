{ pkgs, ... }:

let
  cursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
  };
  size = 24;
in
{
  # Set x11 cursor
  hm.home.pointerCursor = cursor;

  # Set gtk cursor
  hm.gtk.cursorTheme = cursor;

  environment.variables = {
    HYPRCURSOR_THEME = cursor.name;
    HYPRCURSOR_SIZE = size;
    XCURSOR_THEME = cursor.name;
    XCURSOR_SIZE = size;
  };
}
