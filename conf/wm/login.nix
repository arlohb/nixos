{ pkgs, ... }:

{
  # Enable X
  services.xserver.enable = true;

  # Display manager
  services.xserver.displayManager.lightdm = {
    enable = true;

    greeters.gtk.enable = true;

    greeters.gtk.extraConfig = ''
      [greeter]
      active-monitor=0
    '';
  };
}
