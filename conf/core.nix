{ pkgs, ... }:

{
  # Core nix settings
  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Full package and hardware support
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Core packages
  pkgs = with pkgs; [
    git
    wget
    curl
    zip
    unzip
    neofetch
    btop
  ];
}
