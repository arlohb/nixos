{ pkgs, hostname, ... }:

{
  pkgs = with pkgs; [
    # Used to disable xorg / xwayland access control
    xorg.xhost
  ];

  # Enable X
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    nvidiaPatches = false;
  };

  # Link over all the config files
  hm.home.file."/home/arlo/.config/hypr" = {
    source = ./.;
    recursive = true;
  };

  # Add hostname specific config for hyprland
  hm.home.file."/home/arlo/.config/hypr/monitors.conf" = {
    source =
      if hostname == "arlo-nix" then
        ./maybe/arlo-nix.conf
      else
        ./maybe/arlo-laptop2.conf;
  };
}

