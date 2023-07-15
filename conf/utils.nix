rec {
  # Lots of very common options are very long,
  # So I've remapped them to shorter names:
  #   - environment.systemPackages                           -> pkgs
  #   - environment.persistence."/nix/persistent"            -> persist
  #   - environment.persistence."/nix/persistent".users.arlo -> userPersist
  #   - home-manager.users.arlo                              -> hm
  #
  # The other reason for this function it to provide special inputs to the modules.
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

  # This runs the betterModule function on a list of module paths.
  # The purporse of this is the add in the moduleInputs.
  #
  # This is harder than it should be, as I have to destructor them,
  # even if I don't use them.
  # I believe this is so NixOS knows which module inputs to provide to the module,
  # as even in a completely lazy language, all the module inputs may be too much?
  loadBetterModules = specialInputs: map (
    path:
    { pkgs, config, lib, ... }@moduleInputs:
    betterModule specialInputs (import path) moduleInputs
  );
}
