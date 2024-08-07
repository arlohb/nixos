{
  # Generated with:
  # nix run nixpkgs#mkpasswd -- -m SHA-512 -s
  initialHashedPassword = "$id$salt$hash";

  # Git user info
  git = {
    userName = "username";
    userEmail = "email";
  };
  # Copied to ~/.config/git/credentials
  git-credentials = "https://user:password@host.com";

  # Nextcloud server info
  nextcloud = {
    server = "https://www.host.com";
    user = "username";
    password = "password";
  };

  ssh = {
    extraConfig = ''
      Host NAME
        Hostname HOST
        Port PORT
        User USER
    '';

    # This is for ssh servers,
    # and allows the owner of the associated private key owner to login
    authorizedKeys = [
      "publickey"
    ];
  };

  duckDns = {
    domain = "domain";
    token = "token";
  };
}
