{ system, pkgs, inputs, ... }:

{
  # Core nix settings
  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = system;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.use-xdg-base-directories = true;
  # Checks for duplicate files in the store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

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

  # NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import inputs.nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };
  };
}
