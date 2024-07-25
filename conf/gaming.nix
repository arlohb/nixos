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
      custom.start = "notify-send 'GameMode started!'";
      custom.end = "notify-send 'GameMode ended!'";
    };
  };

  # Steam
  programs.steam.enable = true;

  # Minecraft bedrock
  services.flatpak.packages = [
    "io.mrarm.mcpelauncher"
  ];

  # Other programs
  pkgs = with pkgs; [
    # micro-compositor to speed up game rendering under wayland
    # Installed here instead of in scripts where its used,
    # As other programs like lutris and retroarch can use this
    gamescope

    # Minecraft launcher for various modpack sources
    prismlauncher

    # Game launcher for non-linux games
    lutris
    wineWowPackages.waylandFull

    # Proton-GE installer
    # This installs it to ~/.local/share/Steam/compatibilitytools.d,
    # So is already persisted with the steam installation
    protonup-ng

    # Free Magic The Gathering
    cockatrice

    (retroarch.override {
      cores = with libretro; [
        citra
      ];
    })
  ];

  # https://nixos.wiki/wiki/Lutris
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
