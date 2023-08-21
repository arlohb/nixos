{ pkgs, ...}:

{
  pkgs = with pkgs; [
    # Ran on shell start
    dwt1-shell-color-scripts
    # ls replacement
    exa
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -U fish_greeting
      colorscript -r

      function nr
        nix run "nixpkgs#$argv"
      end

      function ns
        nix shell "nixpkgs#$argv"
      end

      function whichreal
        readlink (which $argv)
      end
    '';

    shellAliases = {
      ls = "exa --all --long --icons --binary --no-time --git --no-permissions --no-user";

      lsl = "exa --all --long --icons --binary --no-time --git --group";
    };
  };

  users.defaultUserShell = pkgs.fish;

  hm.programs.direnv.enable = true;

  userPersist.directories = [
    ".local/share/direnv"
  ];
}
