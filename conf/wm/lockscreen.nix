{ pkgs, ... }:

{
  hm.programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
    };
  };

  security.pam.services.swaylock = { };
}
