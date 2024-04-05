{ pkgs, ... }:

{
  pkgs = with pkgs; [
    android-studio
  ];

  userPersist.directories = [
    ".local/share/Android"
    ".local/share/Google"
    ".config/Google"
    # Couldn't change even after trying very hard
    ".android"
  ];
}

