{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk.override { enableJavaFX = true; };
  };

  pkgs = with pkgs; [
    jetbrains.idea-community
  ];

  userPersist.directories = [
    ".local/share/Jetbrains"
    ".config/JetBrains"
  ];
}

