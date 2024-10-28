{ pkgs, ... }:

{
  # Gamemode give games various optimisations
  programs.gamemode = {
    enable = true;

    settings = {
      general = {
        reaper_freq = 5;
        desiredgov = "performance";
        igpu_desiredgov = "performance";
        igpu_power_threshold = 0.3;
        softrealtime = "auto";
        renice = 0;
        ioprio = 0;
        inhibit_screensaver = 1;
      };

      gpu.amd_performance_level = "high";

      # This could do more complicated things in the future
      custom.start = "${pkgs.libnotify}/bin/notify-send 'GameMode started!'";
      custom.end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended!'";
    };
  };

  # Gamescope for better gaming on wayland
  programs.gamescope = {
    enable = true;
    args = [
      # Linked Hyprland issue: https://github.com/hyprwm/Hyprland/issues/6376
      "--backend sdl"
    ];
  };

  # Steam
  programs.steam.enable = true;

  # Minecraft bedrock
  services.flatpak.packages = [
    "io.mrarm.mcpelauncher"
  ];

  # Other programs
  pkgs = with pkgs; [
    # Minecraft launcher for various modpack sources
    prismlauncher

    # Game launcher for non-linux games
    lutris
    wineWowPackages.waylandFull

    # Proton-GE installer
    # This installs it to ~/.local/share/Steam/compatibilitytools.d,
    # So is already persisted with the steam installation
    # TODO: Look at programs.steam.extraCompatPackages and proton-ge-bin
    protonup-ng

    # Free Magic The Gathering
    cockatrice

    # Temporarily disabled as it failed to build
    # (retroarch.override {
    #   cores = with libretro; [
    #     citra
    #   ];
    # })
  ];

  # https://nixos.wiki/wiki/Lutris
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Enable support for bluetooth xbox controllers
  hardware.xpadneo.enable = true;

  userPersist = {
    directories = [
      ".local/share/Steam"
      ".local/share/PrismLauncher"
      ".local/share/lutris"
      ".config/lutris"
      ".local/share/Cockatrice"
      ".config/retroarch"

      # Minecraft Bedrock Launcher
      # https://mcpelauncher.readthedocs.io/en/latest/index.html
      ".config/Minecraft Linux Launcher"
      ".local/share/mcpelauncher"
      ".local/share/mcpelauncher-webview"
      ".local/share/Minecraft Linux Launcher"
    ];
  };
}
