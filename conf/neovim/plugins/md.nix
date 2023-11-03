{ pkgs, custom, ... }:
with pkgs.vimPlugins; [
  {
    plugin = vim-markdown;
    config = ''
      -- Enable the link folding
      vim.opt.conceallevel = 2

      -- Open all folds by default
      vim.g.vim_markdown_folding_level = 6
      vim.opt.foldlevel = 99
    '';
  }

  {
    plugin = custom.obsidian-nvim;
    config = ''
      require("obsidian").setup {
        dir = "~/Nextcloud/Vault",
        notes_subdir = "Cards",

        daily_notes = {
          folder = "Journal/Dailies",
          date_format = "%Y-%m-%d",
        },

        completion = {
          nvim_cmp = true,
          new_notes_location = "notes_subdir",
          prepend_note_id = false,
        },

        disable_frontmatter = true,

        follow_url_func = function(url)
          vim.fn.jobstart({ "xdg-open", url })
        end,

        -- We're gonna create the mapping ourself
        mappings = {},
      }

      vim.keymap.set("n", "gf", "<cmd>ObsidianFollowLink<cr>")
    '';
  }

  {
    plugin = custom.image-nvim;
    config = ''
      require("image").setup {
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            download_remote_images = true,
            clear_in_insert_mode = true,
          },
        },
        max_width = 35,
        window_overlap_clear_enabled = true,
      }
    '';
  }
]
