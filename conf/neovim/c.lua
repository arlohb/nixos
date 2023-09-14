-- I need a better solution:
-- right now, one fails every time a file opens.
require("lspconfig").ccls.setup {}
require("lspconfig").clangd.setup {}
