require("lspconfig").clangd.setup {
    -- This flag doesn't seem to work
    cmd = { "clangd", "--clang-tidy" },
}
