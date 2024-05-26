{ inputs, pkgs, lib, ... }@moduleInputs:
{
  pkgs = with pkgs; [
    inputs.nixvim.packages."${system}".default
    wl-clipboard
  ];

  userPersist.directories = [
    ".config/nvim/spell"
    ".local/share/nvim"
    ".local/state/nvim"
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
