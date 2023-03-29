{ config, pkgs, ... }:

{
  # See home.nix for more installed packages
  # I've used codes for packages that are elsewhere
  #  FM = Flake Module
  #  HM = Home Manager
  #  OC = Other Config
  environment.systemPackages = with pkgs; [
    # Absolutely vital
    git
    wget                      # Also nvim requirement
    curl
    zip
    unzip

    # Laptop
    brightnessctl

    # Audio
    # OC - wireplumber
    pamixer

    # Window manager stuff
    # FM - Hyprland
    libnotify                 # For testing configs
    nur.repos.aleksana.swww   # For setting backgrounds
    eww-wayland               # The top bar and more
    grim                      # Screen capture for sc
    slurp                     # Region selection for sc

    # Basic programs
    neofetch                  # Pretty
    feh                       # Image viewer
    rofi                      # App launcher

    # Editor
    # HM - neovim
    neovide

    vivaldi
    obsidian
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  environment.shellAliases = {
    neonix = ''nix develop --command bash -c "WINIT_UNIX_BACKEND=x11 neovide --nofork --multigrid ."'';
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
