{ pkgs, hostname, ... }:

{
  # Enable X
  # services.xserver.enable = true;

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

    handlers.lock = {
      event = "button/lid.*.close";
      action = ''
        ${pkgs.su}/bin/su arlo -c ' \
        XDG_RUNTIME_DIR=/run/user/1000 \
        WAYLAND_DISPLAY=wayland-1 \
        ${pkgs.swaylock-effects}/bin/swaylock ' '';
    };
  } else { };
}
