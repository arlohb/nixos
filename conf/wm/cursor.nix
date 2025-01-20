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

  environment.variables = {
    HYPRCURSOR_THEME = cursor.name;
    HYPRCURSOR_SIZE = 24;
    XCURSOR_THEME = cursor.name;
    XCURSOR_SIZE = 24;
  };
}
