{ pkgs, custom, ... }:
with pkgs.vimPlugins; [
  # Maybe in the future
  # - https://github.com/jakewvincent/mkdnflow.nvim
  # - https://github.com/iamcco/markdown-preview.nvim
  # - https://alpha2phi.medium.com/neovim-for-beginners-note-taking-writing-diagramming-and-presentation-72d301aae28

  {
    plugin = mkdnflow-nvim;
    config = ''
      require("mkdnflow").setup {
        modules = {
          bib = false,
          maps = false,
          -- TODO maybe change to this from vim-table-mode
          tables = false,
        },
        perspective = {
          priority = "root",
          root_tell = "Scratch.md"
        },
        links = {
          style = "wiki",
          conceal = true,
          transform_implicit = function(input)
            -- If path is http(s):// or file:
            if input:find(":") then
              return input
            end

            return "**/"..input..".md"
          end,
        },
        create_dirs = false,
      }

      vim.keymap.set("n", "gf", "<cmd>MkdnEnter<cr>")
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

  vim-table-mode
]
