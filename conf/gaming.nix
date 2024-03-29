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

  # Other programs
  pkgs = with pkgs; [
    # micro-compositor to speed up game rendering under wayland
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
  hardware.opengl.driSupport32Bit = true;

  userPersist = {
    directories = [
      ".local/share/Steam"
      ".local/share/PrismLauncher"
      ".local/share/lutris"
      ".config/lutris"
      ".local/share/Cockatrice"
      ".config/retroarch"
    ];
  };
}
