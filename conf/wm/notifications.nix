{ pkgs, ... }:

{
  services.earlyoom.killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
    # Dunst is arlo's user service, so root can't see it.
    # And setting DISPLAY is a bit of a hack.
    DISPLAY=:0 \
    /run/wrappers/bin/su arlo -c ' \
      dunstify -u critical "Had to kill a process!" "(Should) be fine now" \
    '
  '';

  hm.services.dunst = {
    enable = true;

    # Most of this is from here:
    # https://github.com/dracula/dunst/blob/master/dunstrc
    settings = {
      global = {
        # Position
        follow = "mouse"; # Which monitor
        width = 300;
        height = 300;
        origin = "center";

        # Progress Bar
        progress_bar_height = 10;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 2;

        # Looks
        frame_width = 2;
        frame_color = "#f8f8f2";
        separator_color = "frame";
        corner_radius = 10;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        text_icon_padding = 0;

        # Text
        font = "FiraCode Nerd Font 10";
        line_height = 0;
        # Allows pango markup
        markup = "full";
        format = "%s %p\\n%b";
        alignment = "center";
        vertical_alignment = "center";
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;

        # Display
        sort = true;
        idle_threshold = 120;
        show_age_threshold = 60;

        # History
        sticky_history = true;
        history_length = 20;

        # Actions
        dmenu = "/usr/bin/env rofi -dmenu -p dunst";
        browser = "/usr/bin/env firefox";
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";

      };

      urgency_low = {
        background = "#282a36";
        foreground = "#6272a4";
        highlight = "#6272a4";
        timeout = 10;
      };

      urgency_normal = {
        background = "#282a36";
        foreground = "#bd93f9";
        highlight = "#bd93f9";
        timeout = 10;
      };

      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        highlight = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };
}
