{ pkgs, config, ... }:

let
  secrets = import ../secrets.nix;
in
{
  pkgs = with pkgs; [
    # Secret management
    git-crypt # Automatically encrypts secret files in git repos
    #          I use this in nixos config for secrets.nix
    scrypt # Encrypts files with passwords
    #         I use this so I can store the git-crypt key file
    #         in a secure-ish place, that's not acc. that secure

    jujutsu
  ];

  hm.home.file."/home/arlo/.config/jj/config.toml".text = ''
    "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

    [ui]
    paginate = "auto"
    pager = [ "less", "-RFX" ]

    [user]
    name = "${secrets.git.userName}"
    email = "${secrets.git.userEmail}"
  '';

  # Setup git
  hm.programs = {
    git = secrets.git // {
      enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        # Store credentials here
        # This file is created from secrets
        credential.helper = "store --file ${config.sops.secrets.git-credentials.path}";
      };
    };
  };
}
