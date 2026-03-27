{ pkgs, ... }:

{
  pkgs = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Required until this PR is merged
    # https://github.com/Mic92/sops-nix/pull/928
    # That should fix it
    age.keyFile = "/nix/persistent/home/arlo/.config/sops/age/keys.txt";

    secrets = {
      nix-access-tokens.owner = "arlo";
      git-credentials.owner = "arlo";

      "duckdns/domain" = {};
      "duckdns/token" = {};

      "nextcloud/server".owner = "arlo";
      "nextcloud/user".owner = "arlo";
      "nextcloud/password".owner = "arlo";

      k3s-token = {};
    };
  };

  userPersist.directories = [
    ".config/sops"
  ];

  # fileSystems."/home/arlo/.config/sops".neededForBoot = true;
}
