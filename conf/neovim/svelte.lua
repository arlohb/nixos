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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("lspconfig").html.setup {
  capabilities = capabilities,
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

require("lspconfig").cssls.setup {
  capabilities = capabilities,
}

