{ pkgs, config, hostname, ... }:

let
  secrets = import ../secrets.nix;
in
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
      nixconfig = { };
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

  # Setup home manager
  hm.home = {
    stateVersion = "23.05";

    username = "arlo";
    homeDirectory = "/home/arlo";

    # Link over all files in ../config to ~/.config
    file."/home/arlo/.config" = {
      source = ../config;
      recursive = true;
    };

    # Create a git credential file from secrets
    file."/home/arlo/.config/git/credentials" = {
      text = secrets.git-credentials;
    };
  };

  # Setup git
  hm.programs = {
    git = secrets.git // {
      enable = true;

      extraConfig = {
        # Store credentials here
        # This file is created from secrets
        credential.helper = "store --file ~/.config/git/credentials";
        # This is needed for a normal user to control a git repo
        # owned by root, even though it's in the owning group
        safe.directory = "/etc/nixos";
      };
    };
  };

  pkgs = with pkgs; [
    # Secret management
    git-crypt # Automatically encrypts secret files in git repos
    #          I use this in nixos config for secrets.nix
    scrypt # Encrypts files with passwords
    #         I use this so I can store the git-crypt key file
    #         in a secure-ish place, that's not acc. that secure

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
  ] else [ ]);

  userPersist.directories = [
    # User files
    "code"
    "Vault"
    "3d"
    # Cache
    ".cache"
    # Various programs' configuration
    ".config/obsidian"
    ".config/vivaldi"
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
  };
}
