{ options, config, lib, ... }:
with lib;
let
  # Usually would be a property, but this is in the global scope
  cfg = config;
in {
  # Lots of very common options are very long,
  # So I've remapped them to shorter names:
  #   - environment.systemPackages                           -> pkgs
  #   - environment.persistence."/nix/persistent"            -> persist
  #   - environment.persistence."/nix/persistent".users.arlo -> userPersist
  #   - home-manager.users.arlo                              -> hm

  options = {
    aliases.enable = mkEnableOption "pkgs alias";

    pkgs = options.environment.systemPackages;

    # I can't work out how to get nested options to automate this

    persist = mkOption {
      description = "Alias for environment.persistence.\"nix/persistence\"";
      type = with types; submodule {
        options = {
          hideMounts = mkOption {
            type = bool;
          };
          directories = mkOption {
            type = listOf str;
            default = [];
          };
          files = mkOption {
            type = listOf str;
            default = [];
          };
        };
      };
    };

    userPersist = mkOption {
      description = "Alias for environment.persistence.\"nix/persistence\".users.arlo";
      type = with types; submodule {
        options = {
          directories = mkOption {
            type = listOf str;
            default = [];
          };
          files = mkOption {
            type = listOf str;
            default = [];
          };
        };
      };
    };

    hm = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
  };

  config = mkIf cfg.aliases.enable {
    environment.systemPackages = cfg.pkgs;
    environment.persistence."/nix/persistent" = cfg.persist // {
      users.arlo = cfg.userPersist;
    };

    home-manager.users.arlo = cfg.hm;
  };
}
