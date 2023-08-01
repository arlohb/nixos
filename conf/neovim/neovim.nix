{ inputs, pkgs, lib, ... }:
let
  # Not in nixpkgs (yet)
  nvim-spider = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-spider";
    src = inputs.nvim-spider;
  };
  obsidian-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "obsidian.nvim";
    src = inputs.obsidian-nvim;
  };
  drop-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "drop.nvim";
    src = inputs.drop-nvim;
  };
in
{
  pkgs = with pkgs; [
    # Nvim requirements
    ripgrep
    fd
    tree-sitter
    gcc
    wl-clipboard
  ];

  userPersist.directories = [
    ".local/share/nvim"
    ".local/state/nvim"
  ];

  hm.programs.neovim = {
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
        ./fsharp.lua
        ./rust.lua
        ./svelte.lua
        ./c.lua
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
            require("spider").setup {
              skipInsignificantPunctuation = false,
            }

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
                winblend = 0,
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
                winblend = 0,
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
              :with_pair(cond.not_before_regex(" "))
            )
          '';
        }

        # Provides correct tabbing and syntax highlighting
        nvim-treesitter.withAllGrammars

        # Magit clone
        {
          plugin = neogit;
          config = ''
            require("neogit").setup {
              kind = "replace",
            }
          '';
        }

        # Git diffs in file
        {
          plugin = gitsigns-nvim;
          config = ''
            require("gitsigns").setup()
          '';
        }

        # LSP
        nvim-lspconfig
        rust-tools-nvim

        # Completion
        nvim-cmp
        vim-vsnip
        cmp-nvim-lsp
        cmp-path
        cmp-nvim-lua
        {
          plugin = lsp_signature-nvim;
          config = ''
            require("lsp_signature").setup {
              bind = true, -- This is mandatory, otherwise border config won't get registered.
              handler_opts = {
                border = "rounded"
              }
            }
          '';
        }

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

        # Nicer notification UI
        {
          plugin = nvim-notify;
          config = ''
            vim.notify = require("notify")
            require("telescope").load_extension("notify")
          '';
        }

        {
          plugin = alpha-nvim;
          config = "
            require('alpha').setup {
              layout = {
                {
                  type = 'padding',
                  val = 12,
                },
                {
                  type = 'text',
                  val = [[
                                  ....
                                .'' .'''
.                             .'   :
\\\\                          .:    :
 \\\\                        _:    :       ..----.._
  \\\\                    .:::.....:::.. .'         ''.
   \\\\                 .'  #-. .-######'     #        '.
    \\\\                 '.##'/ ' ################       :
     \\\\                  #####################         :
      \\\\               ..##.-.#### .''''###'.._        :
       \\\\             :--:########:            '.    .' :
        \\\\..__...--.. :--:#######.'   '.         '.     :
        :     :  : : '':'-:'':'::        .         '.  .'
        '---'''..: :    ':    '..'''.      '.        :'
           \\\\  :: : :     '      ''''''.     '.      .:
            \\\\ ::  : :     '            '.      '      :
             \\\\::   : :           ....' ..:       '     '.
              \\\\::  : :    .....####\\\\ .~~.:.             :
               \\\\':.:.:.:'#########.===. ~ |.'-.   . '''.. :
                \\\\    .'  ########## \\ \\ _.' '. '-.       '''.
                :\\\\  :     ########   \\ \\      '.  '-.        :
               :  \\\\'    '   #### :    \\ \\      :.    '-.      :
              :  .'\\\\   :'  :     :     \\ \\       :      '-.    :
             : .'  .\\\\  '  :      :     :\\ \\       :        '.   :
             ::   :  \\\\'  :.      :     : \\ \\      :          '. :
             ::. :    \\\\  : :      :    ;  \\ \\     :           '.:
              : ':    '\\\\ :  :     :     :  \\:\\     :        ..'
                 :    ' \\\\ :        :     ;  \\|      :   .'''
                 '.   '  \\\\:                         :.''
                  .:..... \\\\:       :            ..''
                 '._____|'.\\\\......'''''''.:..'''
                            \\\\
                  ]],
                  opts = {
                    position = 'center',
                  },
                },
              },
            }
          ";
        }

        {
          plugin = drop-nvim;
          config = ''
            require("drop").setup {
              theme = "snow",
              max = 1000,
              interval = 70,
              screensaver = false,
            }
          '';
        }

        # Yuck (eww) syntax support
        yuck-vim

        # Good F# support
        Ionide-vim

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
        {
          plugin = direnv-vim;
          config = ''
            -- This is my own variable not direnv's
            -- I want to ignore the first time (when nvim starts),
            -- and only notify the second time.
            vim.g.direnv_already_notified = -1

            vim.g.direnv_silent_load = 1

            vim.api.nvim_create_autocmd(
              "User",
              {
                pattern = "DirenvLoaded",
                callback = function(_e)
                  if vim.g.direnv_already_notified == 0 then
                    vim.notify("Direnv loaded")
                  end

                  -- Lua doesn't have ++ or += 😞
                  vim.g.direnv_already_notified = vim.g.direnv_already_notified + 1
                end,
              }
            )
          '';
        }

        # Obsidian
        {
          plugin = obsidian-nvim;
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
          plugin = vim-smoothie;
          config = ''
            -- Enables gg and G
            vim.g.smoothie_experimental_mappings = true
          '';
        }
      ]);
  };
}
