{ pkgs, hostname, ... }:

{
  pkgs = with pkgs; [
    unityhub
    dotnet-sdk_9
    # Required for unity web build
    python3
    # Required for unity audio import (sometimes, maybe only for web)
    ffmpeg
  ];

  userPersist.directories = [
    ".config/unity3d"
    ".config/unityhub"
    ".local/share/Unity"
  ];
}
