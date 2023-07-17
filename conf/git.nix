{ pkgs, ... }:

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
  ];

  # Create a git credential file from secrets
  hm.home.file."/home/arlo/.config/git/credentials" = {
    text = secrets.git-credentials;
  };

  # Setup git
  hm.programs = {
    git = secrets.git // {
      enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        # Store credentials here
        # This file is created from secrets
        credential.helper = "store --file ~/.config/git/credentials";
        # This is needed for a normal user to control a git repo
        # owned by root, even though it's in the owning group
        safe.directory = "/etc/nixos";
      };
    };
  };
}
