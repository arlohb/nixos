hostname: { config, pkgs, ... }:

{
  # Normal users
  users = {
    # Useradd etc won't work
    mutableUsers = false;

    # Custom groups
    groups = {
      # A user that can modify /etc/nixos
      # The git repo can be changed to this with these commands:
      # cd /etc/nixos
      # sudo chgrp -R nixconfig .
      # sudo chmod  -R g+rw .
      # sudo chmod g+s `find . -type d` # (change `` to () for fish)
      # git init --bare --shared=all .
      nixconfig = {};
    };

    # The normal user
    users.arlo = {
      isNormalUser = true;
      # wheel - can use sudo
      # video - various video things
      # nixconfig - rw for /etc/nixos
      extraGroups = [ "wheel" "video" "nixconfig" ];
      # Give the user a password from secrets
      initialHashedPassword = (import ../secrets.nix).initialHashedPassword;
    };
  };

  # See home.nix for more installed packages
  # I've used codes for packages that are elsewhere
  #  FM = Flake Module
  #  HM = Home Manager
  #  OC = Other Config
  environment.systemPackages = with pkgs; [
    # Secret management
    git-crypt # Automatically encrypts secret files in git repos
              # I use this in nixos config for secrets.nix
    scrypt # Encrypts files with passwords
           # I use this so I can store the git-crypt key file
           # in a secure-ish place, that's not acc. that secure

    # Basic programs
    neofetch # Pretty
    feh # Image viewer
    rofi # App launcher
    gparted # Disk manager

    # Editor
    # HM - neovim
    neovide

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    obsidian
  ] ++ (if hostname == "arlo-laptop2" then [
    # Laptop
    brightnessctl
  ] else []);

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

  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
  };
}
