{ pkgs, ... }:

{
  services.kmonad = {
    enable = true;
    keyboards.laptopKbd = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

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
  };
}
