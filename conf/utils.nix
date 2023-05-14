rec {
  betterModule =
    # Inputs not part of usual nixos modules
    # This includes the system hostname
    specialInputs:
    # The actual module
    module:
    # The usual nixos module inputs
    moduleInputs:
    let
      origin = module (moduleInputs // specialInputs);

      pkgs = origin.pkgs or [ ];
      persist = origin.persist or { };
      userPersist = origin.userPersist or { };
      hm = origin.hm or { };

      final = builtins.removeAttrs origin [
        "pkgs"
        "persist"
        "userPersist"
        "hm"
      ];
    in
    final
    // {
      environment = {
        persistence."/nix/persistent" = persist // {
          users.arlo = userPersist;
        };

        systemPackages = pkgs;
      };

      home-manager.users.arlo = hm;
    };

  loadBetterModules = specialInputs: map (
    path:
    { pkgs, config, lib, ... }@moduleInputs:
    betterModule specialInputs (import path) moduleInputs
  );
}
