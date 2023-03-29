{ config, pkgs, ... }:

{
  system.stateVersion = "23.05";

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/NUR/archive/02fe4ead56489bd62b2967c51e0f1dda2ff6066f.tar.gz";
      # Found with `nix-prefetch-url --unpack {above url}`
      sha256 = "1vpwilcpcnh4h8j0y8p5h2g46xw5fy9iywl9rg8xr21imwh7ys8h";
    }) {
      nurpkgs = pkgs;
      inherit pkgs;
    };
  };
}
