{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
      colorscript -r
    '';
  };

  users.defaultUserShell = pkgs.fish;

  environment.shellAliases = {
    neonix = ''
      nix develop --command bash -c "WINIT_UNIX_BACKEND=x11 neovide --nofork --multigrid ."
    '';
  };

  hm.programs = {
    # Setup the terminal emulator
    kitty = {
      enable = true;

      # Home manager can install this with `font.package`,
      # But I use this everywhere to I can assume it's installed
      font.name = "FiraCode Nerd Font";
      font.size = 10.8;

      # Inbuilt to kitty
      theme = "Dracula";

      settings = {
        # Some ligature settings I prefer
        font_features =
          "FiraCodeNerdFontComplete-Regular +cv01 +ss03 +ss04 +ss08 +cv02";
        disable_ligatures = "never";
        enable_audio_bell = false;
        background_opacity = "0.5";
        confirm_os_window_close = 0;
      };
    };

    direnv = {
      enable = true;
    };
  };

  # The best font ever!
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  userPersist.directories = [
    ".local/share/fish"
    ".local/share/direnv"
  ];
}