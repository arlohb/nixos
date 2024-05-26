{ pkgs, ... }:
with pkgs.vimPlugins; [
  # Better word movements
  {
    plugin = nvim-spider;
    config = ''
      require("spider").setup {
        skipInsignificantPunctuation = false,
      }

      vim.keymap.set({"n", "o", "x"}, "w", function() require("spider").motion("w") end, { desc = "Spider-w" })
      vim.keymap.set({"n", "o", "x"}, "e", function() require("spider").motion("e") end, { desc = "Spider-e" })
      vim.keymap.set({"n", "o", "x"}, "b", function() require("spider").motion("b") end, { desc = "Spider-b" })
      vim.keymap.set({"n", "o", "x"}, "ge", function() require("spider").motion("ge") end, { desc = "Spider-ge" })
    '';
  }

  # Autopair brackets and other stuff
  {
    plugin = nvim-autopairs;
    config = ''
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      local npairs = require("nvim-autopairs")

      require("nvim-autopairs").setup {}

      npairs.add_rule(Rule("<", ">")
        :with_move(cond.move_right)
        :with_pair(cond.not_before_regex(" "))
      )
    '';
  }

  # Surround selections
  {
    plugin = nvim-surround;
    config = ''
      require("nvim-surround").setup {}
    '';
  }

  # Comment and uncomment lines easily
  vim-commentary

  # Detect tab width and other stuff
  # This also read editorconfig
  vim-sleuth

  # Open files as sudo
  {
    plugin = vim-suda;
    config = ''
      vim.g.suda_smart_edit = 1
    '';
  }

  {
    plugin = vim-smoothie;
    config = ''
      -- Enables gg and G
      vim.g.smoothie_experimental_mappings = true
    '';
  }
]
