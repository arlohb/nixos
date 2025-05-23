{ pkgs, ... }:

{
  pkgs = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/arlo/.config/sops/age/keys.txt";

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

  fileSystems."/home/arlo/.config/sops".neededForBoot = true;
}
