{ config, pkgs, ... }:

{
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

      custom.start = "notify-send 'GameMode started!'";
      custom.end = "notify-send 'GameMode ended!'";
    };
  };

  programs.steam.enable = true;
}
