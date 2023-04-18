{ config, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  home = {
    stateVersion = "23.05";

    username = "root";
    homeDirectory = "/root";
  };

  programs.git = secrets.git // { enable = true; };
}
