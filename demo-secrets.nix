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
}
