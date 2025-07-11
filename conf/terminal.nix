{ pkgs, ... }:

{
  # Setup the terminal emulator
  hm.programs.kitty = {
    enable = true;

    # Home manager can install this with `font.package`,
    # But I use this everywhere to I can assume it's installed
    font.name = "FiraCode Nerd Font SemBd";
    font.size = 10.8;

    extraConfig = ''
      italic_font   VictorMono NF SemiBold Italic
      bold_font     FiraCode Nerd Font Bold
    '';

    # Inbuilt to kitty
    theme = "Dracula";

    keybindings = {
      # Disable quit hotkey
      "ctrl+shift+w" = "";
      "ctrl+backspace" = "send_text all \\x17";
      "ctrl+t" = "set_background_opacity 1";
      "ctrl+shift+t" = "set_background_opacity default";
    };

    shellIntegration.mode = "enabled";

    settings = {
      # Some ligature settings I prefer
      font_features =
        "FiraCodeNerdFontComplete-Regular +cv01 +ss03 +ss04 +ss08 +cv02";
      disable_ligatures = "never";
      enable_audio_bell = false;
      dynamic_background_opacity = true;
      background_opacity = "0.5";
      confirm_os_window_close = 0;
    };
  };

  programs.fish.shellAliases.s = "kitten ssh";

  # The best font ever!
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.victor-mono
  ];
}
