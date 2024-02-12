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

  # The best font ever!
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [
      "FiraCode"
      "VictorMono"
    ]; })
  ];

  userPersist.directories = [
    ".local/share/fish"
  ];
}
