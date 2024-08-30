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
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  programs.nix-ld.enable = true;
  # Allows you to run unpatched binaries
  hardware.enableAllFirmware = true;

  # Locate pkgs
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Core packages
  pkgs = with pkgs; [
    busybox
    usbutils
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
