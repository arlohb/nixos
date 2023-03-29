{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./conf/core.nix
    ./conf/base.nix
    ./conf/gaming.nix
  ];

  networking.hostName = "arlo-laptop2";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.users.arlo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };
}

