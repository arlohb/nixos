{ pkgs, ... }:
with pkgs.vimPlugins; [
  # The theme(s)
  {
    plugin = sonokai;
    config = ''
      vim.g.sonokai_style = "andromeda"
      -- This unfortunately tried to modify the read-only filesystem,
      -- and can't be configured not to
      vim.g.sonokai_better_performance = 0
      -- vim.cmd("colorscheme sonokai")
    '';
  }
  kanagawa-nvim
  neovim-ayu
  embark-vim
  nightfox-nvim
  jellybeans-nvim
  oxocarbon-nvim
  {
    plugin = dracula-nvim;
    config = ''
      require("dracula").setup {}
      vim.cmd("colorscheme dracula")
    '';
  }
  vim-horizon
  catppuccin-nvim

  # The status line at the bottom
  {
    plugin = lualine-nvim;
    config = ''
      require("lualine").setup {
        options = {
          theme = "auto",
          disabled_filetypes = { "NvimTree", "alpha" },
        },
      }
    '';
  }

  # Makes UI nicer
  {
    plugin = dressing-nvim;
    config = ''
      require("dressing").setup {}
    '';
  }

  # Nicer notification UI
  {
    plugin = nvim-notify;
    config = ''
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
    '';
  }

  # Git diffs in file
  {
    plugin = gitsigns-nvim;
    config = ''
      require("gitsigns").setup()
    '';
  }

  # Show thin lines at indents
  {
    plugin = indent-blankline-nvim;
    config = ''
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- For now this uses dracula colours until I change my nvim theme
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#FF5555" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#F1FA8C" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8BE9FD" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FFB86C" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#50FA7B" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#BD93F9" })
      end)

      require("ibl").setup {
        indent = {
          highlight = {
            "RainbowRed",
            "RainbowOrange",
            "RainbowYellow",
            "RainbowGreen",
            "RainbowBlue",
            "RainbowViolet",
          },
        },
        scope = {
          enabled = false,
        },
      }
    '';
  }
]
