{ pkgs, hostname, ... }:
{
  pkgs = with pkgs; [
    lan-mouse
  ];

  hm.home.file."/home/arlo/.config/lan-mouse/config.toml" = {
    source =
      if hostname == "arlo-nix" then
        ./arlo-nix.toml
      else
        ./arlo-laptop2.toml;
  };
}
