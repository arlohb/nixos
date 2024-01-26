{ pkgs, hostname, lib, ... }:

{
  pkgs = with pkgs; [
    # Used to disable xorg / xwayland access control
    xorg.xhost
    # Used in watch_monitors.sh
    socat
  ];

  # This value is 'compile-time' checked somehow
  services.xserver.displayManager.defaultSession = "hyprland";

  # Enable Hyprland
  programs.hyprland.enable = true;

  hm.wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = lib.concatStrings
      (map (path: (builtins.readFile path) + "\n") [
        ./animations.conf
        ./general.conf
        ./hyprland.conf
        ./input.conf
        ./keys.conf
        ./pretty.conf
        ./rules.conf
      ]);
  };

  # Link over all the config files
  hm.home.file."/home/arlo/.config/hypr" = {
    source = ./scripts;
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

