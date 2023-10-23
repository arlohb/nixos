{ pkgs, ... }:
with pkgs.vimPlugins; [
  # A fuzzy finder with many uses
  {
    plugin = telescope-nvim;
    config = ''
      require("telescope").setup {
        pickers = {
          colorscheme = {
            enable_preview = true
          },
        },
      }
    '';
  }

  # A telescope file browser
  {
    plugin = telescope-file-browser-nvim;
    config = ''
      require("telescope").load_extension("file_browser")
    '';
  }

  # A telescope project manager
  {
    plugin = telescope-project-nvim;
    config = ''
      require("telescope").load_extension("project")
    '';
  }

  # Populates the telescope symbol picker
  telescope-symbols-nvim
]
