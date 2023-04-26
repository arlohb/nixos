{ inputs, pkgs, lib, ... }:
let
  # Not in nixpkgs (yet)
  nvim-spider = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-spider";
    src = inputs.nvim-spider;
  };
in
{
  # Nvim requirements
  home.packages = with pkgs; [ ripgrep fd tree-sitter gcc wl-clipboard ];

  programs.neovim = {
    enable = true;

    # Make it the default with $EDITOR
    defaultEditor = true;

    # Give it nodejs
    withNodeJs = true;

    # Load the lua config
    extraLuaConfig = lib.concatStrings
      (map (path: (builtins.readFile path) + "\n") [
        ./init.lua
        ./keys.lua
        ./lsp.lua
        ./csharp.lua
        ./rust.lua
        ./svelte.lua
      ]);

    plugins = map
      (plugin:
        if builtins.isAttrs plugin then ({ type = "lua"; } // plugin) else plugin)
      (with pkgs.vimPlugins; [
        # Required by loads of plugins
        plenary-nvim
        nvim-web-devicons

        # Better word movements
        {
          plugin = nvim-spider;
          config = ''
            vim.keymap.set({"n", "o", "x"}, "w", function() require("spider").motion("w") end, { desc = "Spider-w" })
            vim.keymap.set({"n", "o", "x"}, "e", function() require("spider").motion("e") end, { desc = "Spider-e" })
            vim.keymap.set({"n", "o", "x"}, "b", function() require("spider").motion("b") end, { desc = "Spider-b" })
            vim.keymap.set({"n", "o", "x"}, "ge", function() require("spider").motion("ge") end, { desc = "Spider-ge" })
          '';
        }

        # Surround selections
        {
          plugin = nvim-surround;
          config = ''
            require("nvim-surround").setup {}
          '';
        }

        # The file tree
        {
          plugin = nvim-tree-lua;
          config = ''
            require("nvim-tree").setup {
              diagnostics = {
                enable = true,
                show_on_dirs = true,
              },
            }
          '';
        }

        # The tooltips when pressing a partial chord
        {
          plugin = which-key-nvim;
          config = ''
            require("which-key").setup {
              window = {
                winblend = 50,
              },
            }
          '';
        }

        # The theme(s)
        {
          plugin = sonokai;
          config = ''
            vim.g.sonokai_style = "andromeda"
            -- This unfortunately tried to modify the read-only filesystem,
            -- and can't be configured not to
            vim.g.sonokai_better_performance = 0
            vim.cmd("colorscheme sonokai")
          '';
        }

        # The status line at the bottom
        {
          plugin = lualine-nvim;
          config = ''
            require("lualine").setup {
              options = {
                theme = "auto",
              },
            }
          '';
        }

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

        # A terminal that can be floating or as a side pane
        {
          plugin = toggleterm-nvim;
          config = ''
            require("toggleterm").setup({
              autochdir = true,
              shade_terminals = false,
              float_opts = {
                border = "curved",
                winblend = 50,
              },
            })
          '';
        }

        # Show thin lines at indents
        indent-blankline-nvim

        # Comment and uncomment lines easily
        vim-commentary

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
            )
          '';
        }

        # Provides correct tabbing and syntax highlighting
        {
          plugin = nvim-treesitter;
          config = ''
            require("nvim-treesitter.configs").setup {
              hightlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
            }
          '';
        }

        # LSP based symbols outline
        vista-vim

        # Git diffs in file
        {
          plugin = gitsigns-nvim;
          config = ''
            require("gitsigns").setup()
          '';
        }

        # LSPs / fmts / DAPs installer
        {
          plugin = mason-nvim;
          config = ''
            require("mason").setup()
          '';
        }

        # LSP
        mason-lspconfig-nvim
        nvim-lspconfig
        rust-tools-nvim

        # Completion
        nvim-cmp
        vim-vsnip
        cmp-nvim-lsp
        cmp-path
        cmp-nvim-lua

        # Connects non LSP stuff into native LSP
        null-ls-nvim

        # JS/TS fmt
        vim-prettier

        # DAP
        nvim-dap
        nvim-dap-virtual-text
        nvim-dap-ui

        # DAP telescope
        {
          plugin = telescope-dap-nvim;
          config = ''
            require("telescope").load_extension("dap")
          '';
        }

        # Makes UI nicer
        {
          plugin = dressing-nvim;
          config = ''
            require("dressing").setup {}
          '';
        }

        # Start screen
        {
          plugin = dashboard-nvim;
          config = ''
            require("dashboard").setup {
              theme = "doom",
              config = {
                -- header = {},
                center = {
                  {
                    icon = " ",
                    desc = "Find File",
                    key = "b",
                    action = "lua print(2)",
                  },
                  {
                    icon = " ",
                    desc = "Projects",
                    key = "SPC f p",
                  },
                },
                -- footer = {},
              },
            }
          '';
        }

        # Yuck (eww) syntax support
        yuck-vim

        # Detect tab width and other stuff
        # This also read editorconfig
        vim-sleuth

        # Open files as sudo
        {
          plugin = suda-vim;
          config = ''
            vim.g.suda_smart_edit = 1
          '';
        }

        # Integrates with direnv
        direnv-vim
      ]);
  };
}
