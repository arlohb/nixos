{ pkgs, hostname, ... }:

{
  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --time --cmd Hyprland";
      user = "greeter";
    };
  };

  security.pam.services.hyprlock = { };
  hm.programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        ignore_empty_input = true;
      };

      background = {
        monitor = "";
        path = "screenshot";

        blur_passes = 3;
        blur_size = 8;
        noise = 0.03;
        contrast = 1.2;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
    };
  };

  services.acpid = if hostname == "arlo-laptop2" then {
    enable = true;

    # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    acEventCommands = ''
      ${pkgs.su}/bin/su arlo -c ' \
        bash -c " \
          XDG_RUNTIME_DIR=/run/user/1000; \
          WAYLAND_DISPLAY=wayland-1; \
          ${pkgs.fish}/bin/fish ~/.config/hypr/performance.fish \
        " \
      '
    '';

    handlers.lock = {
      # use acpi_listen to find event
      event = "button/lid.*.close";
      action = ''
        ${pkgs.su}/bin/su arlo -c ' \
        XDG_RUNTIME_DIR=/run/user/1000 \
        WAYLAND_DISPLAY=wayland-1 \
        ${pkgs.hyprlock}/bin/hyprlock ' '';
    };
  } else { };
}
