require("null-ls").setup({
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end
            })
        end
    end
})

require("lspconfig").tsserver.setup {
    settings = {
        typescript = {
            format = {
                enable = false,
            },
        },
        javascript = {
            format = {
                enable = false,
            },
        },
    },
}

require("lspconfig").svelte.setup {
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end,
    settings = {
        svelte = {
            ["enable-ts-plugin"] = true,
        },
    },
}

require("lspconfig").eslint.setup {}

require("lspconfig").tailwindcss.setup {
    cmd = { "npm", "exec", "tailwindcss-language-server", "--stdio" },
}

