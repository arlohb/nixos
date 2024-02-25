# TODO: Maybe switch to nixvim
# https://github.com/nix-community/nixvim

{ inputs, pkgs, lib, ... }@moduleInputs:
let
  custom = {
    drop-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "drop.nvim";
      src = inputs.drop-nvim;
    };
    vim-nand2tetris-syntax = pkgs.vimUtils.buildVimPlugin {
      name = "vim-nand2tetris-syntax";
      src = inputs.vim-nand2tetris-syntax;
    };
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

    # image.nvim for pdfs
    ghostscript
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
        ./hs.lua
        ./java.lua
      ]);

    extraLuaPackages = lpkgs: [
      # image.nvim requirement
      lpkgs.magick
    ];

    plugins = map
      (plugin:
        if builtins.isAttrs plugin then ({ type = "lua"; } // plugin) else plugin)
        ((lib.foldr (
          file:
          final:
          final ++ ((import file) (moduleInputs // { custom = custom; }))
        ) [] [
          ./plugins/editing.nix
          ./plugins/lsp.nix
          ./plugins/md.nix
          ./plugins/pretty.nix
          ./plugins/start.nix
          ./plugins/telescope.nix
        ]) ++
      (with pkgs.vimPlugins; [
        # Required by loads of plugins
        plenary-nvim
        nvim-web-devicons

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

        # Magit clone
        {
          plugin = neogit;
          config = ''
            require("neogit").setup {
              kind = "replace",
            }
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
      ]));
  };
}
