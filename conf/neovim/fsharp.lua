-- This is the default,
-- But I'm settings it manually so I remember how its working
vim.g["fsharp#backend"] = "nvim"

-- FsAutocomplete is installed by dotnet tool
vim.g["fsharp#fsautocomplete_command"] = {
    "dotnet",
    "fsautocomplete",
    "--adaptive-lsp-server-enabled",
}

-- Idk just saw this somewhere
vim.g["fsharp#exlude_project_directories"] = { "paket-files" }

-- I want to add the format on save autocmd
vim.g["fsharp#lsp_auto_setup"] = 0

require("ionide").setup {
    on_attach = function()
        -- https://github.com/tpope/vim-commentary
        vim.opt_local.commentstring = "// %s"
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buffer,
            callback = function()
                vim.lsp.buf.format { async = false }
            end
        })
    end
}

