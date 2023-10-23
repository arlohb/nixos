{ pkgs, custom, ... }:
with pkgs.vimPlugins; [
  # Provides correct tabbing and syntax highlighting
  nvim-treesitter.withAllGrammars

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

  # Specific languages
  Ionide-vim # Good F# support
  yuck-vim # Yuck (eww) syntax support
  custom.vim-nand2tetris-syntax
]
