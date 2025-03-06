{ pkgs, ... }:
let
  options = {
    defcfg = {
      enable = true;
      # Idk if I always want this,
      # but I figure it helps me not lock myself out
      fallthrough = true;
      # Don't use, unnecessary attack surface
      allowCommands = false;
    };

    config = builtins.readFile ./arlo-laptop2.kbd;
  };
in {
  services.kmonad = {
    enable = true;
    keyboards.laptopKbd = options // {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };
    keyboards.sofleKbd = options // {
      device = "/dev/input/by-id/usb-JosefAdamcik_Sofle_E463A8574B543B2D0000000000000000-event-kbd";
    };
  };
}
