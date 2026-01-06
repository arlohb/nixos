{ pkgs, ... }:

{
  # programs.java = {
  #   enable = true;
  #   package = pkgs.jdk.override { enableJavaFX = true; };
  # };

  pkgs = with pkgs; [
    jetbrains.idea-oss
  ];

  userPersist.directories = [
    ".local/share/JetBrains"
    ".config/JetBrains"
    ".config/java"
  ];
}

