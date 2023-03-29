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

-- require("prettier").setup {}

require("lspconfig").tsserver.setup {
    on_attach = function(_, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
        vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
    end,
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
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
        vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Goto type definition" })

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

require("lspconfig").tailwindcss.setup {}

