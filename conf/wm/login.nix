{ pkgs, hostname, ... }:

{
  # TODO: Setup something like howdy for face recognition
  # Howdy: https://github.com/boltgolt/howdy
  # - NixOS decided not to merge,
  #   because of a (faulty) PAM module
  # - But other people have packaged and stuff
  #   here: https://github.com/NixOS/nixpkgs/issues/76928

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --time --cmd Hyprland";
      user = "greeter";
    };
  };

  hm.programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      effect-pixelate = 30;
    };
  };

  security.pam.services.swaylock = { };

  services.acpid = if hostname == "arlo-laptop2" then {
    enable = true;

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
        ${pkgs.swaylock-effects}/bin/swaylock ' '';
    };
  } else { };
}
