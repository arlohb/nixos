local rt = require("rust-tools")

rt.setup({
    tools = {
        inlay_hints = {
            auto = false,
        },
    },
    server = {
        on_attach = function(_, bufnr)
            -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "K", require("rust-tools").hover_actions.hover_actions, { desc = "Hover" })
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
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
                -- https://github.com/rust-lang/rust-analyzer/issues/7497#issuecomment-770243115
                cargo = {
                    loadOutDirsFromCheck = true,
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
            vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
        ),
    },
})

