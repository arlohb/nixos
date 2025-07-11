{ pkgs, hostname, ...}:

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
        set package $argv[1]
        set args $argv[2..-1]

        # impure to read NIXPKGS_ALLOW_UNFREE
        nix run --impure "nixpkgs#$package" -- $args
      end

      function ns
        set pkg_args
        for pkg in $argv
          set pkg_args $pkg_args "nixpkgs#$pkg"
        end

        # impure to read NIXPKGS_ALLOW_UNFREE
        nix shell --impure $pkg_args
      end

      function whichreal
        readlink (which $argv)
      end

      function cpbig
        # --archive means -rlptgoD
        rsync --archive --human-readable --info=progress2 $argv
      end

      function cpbignet
        # --archive without conserving owner and group
        rsync --archive --no-o --no-g --human-readable --info=progress2 $argv
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

    shellInit = if (hostname == "arlo-laptop1") then ''
      complete --command k --wraps kubectl
    '' else "";
  };

  users.defaultUserShell = pkgs.fish;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # For image.nvim
      set -gq allow-passthrough on
      set -g visual-activity off
    '';
  };

  # TODO: Maybe look into lorri to speed this up
  # https://github.com/nix-community/lorri
  hm.programs.direnv.enable = true;

  userPersist.directories = [
    ".local/share/fish"
    ".local/share/direnv"
  ];
}
