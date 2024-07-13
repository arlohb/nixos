{ pkgs, ... }:

{
  # Create normal users
  users = {
    # Useradd etc won't work
    mutableUsers = false;

    # Custom groups
    groups = {
      # A user that can modify /etc/nixos
      # The git repo can be changed to this with these commands:
      # cd /etc/nixos
      # sudo chgrp -R nixconfig .
      # sudo chmod -R g+rw .
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
      extraGroups = [ "wheel" "video" "audio" "input" "nixconfig" ];
      # Give the user a password from secrets
      initialHashedPassword = (import ../secrets.nix).initialHashedPassword;
    };
  };

  # This is needed for a normal user to control a git repo
  # owned by root, even though it's in the owning group
  hm.programs.git.extraConfig.safe.directory = [
    "/etc/nixos"
    "/etc/nixos/.git"
  ];

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
  };

  hm.xdg.enable = true;

  # Persist user files
  userPersist.directories = [
    # User files
    "code"
    # Cache
    ".cache"
  ];
}
