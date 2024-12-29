{ pkgs, ...}:

{
  pkgs = with pkgs; [
    # Ran on shell start
    dwt1-shell-color-scripts
    # ls replacement
    eza
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -U fish_greeting
      colorscript -r

      function nr
        # To read NIXPKGS_ALLOW_UNFREE
        nix run --impure "nixpkgs#$argv"
      end

      function ns
        # To read NIXPKGS_ALLOW_UNFREE
        nix shell --impure "nixpkgs#$argv"
      end

      function whichreal
        readlink (which $argv)
      end

      function cpbig
        rsync --archive --human-readable --info=progress2 $argv
      end

      if set -q KITTY_INSTALLATION_DIR
          set --global KITTY_SHELL_INTEGRATION enabled
          source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
          set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';

    shellAliases = {
      ls = "eza --all --long --icons --binary --no-time --git --no-permissions --no-user";

      lsl = "eza --all --long --icons --binary --git --group";
    };
  };

  users.defaultUserShell = pkgs.fish;

  # TODO: Maybe look into lorri to speed this up
  # https://github.com/nix-community/lorri
  hm.programs.direnv.enable = true;

  userPersist.directories = [
    ".local/share/fish"
    ".local/share/direnv"
  ];
}
