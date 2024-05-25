function open_file(path)
    -- Sub the ' ' for '\ '
    path = path:gsub(" ", "\\ ")

    -- Create the cmd
    local cmd = "<cmd>e " .. path .. "<cr>"

    -- Run the cmd
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(cmd, true, true, true),
        "n", true
    )
end

-- Documentation is here:
-- https://github.com/folke/which-key.nvim
require("which-key").register({
    ["<leader>"] = {
        -- https://github.com/skbolton/titan/blob/4d0d31cc6439a7565523b1018bec54e3e8bc502c/nvim/nvim/lua/mappings/filesystem.lua#L6
        ["<leader>"] = { function()
            require("telescope.builtin").find_files({
                find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
            )
        end, "Find File" },
        [":"] = { "<cmd>Telescope commands<cr>", "Commands" },

        f = {
            name = "+file",
            r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
            p = { "<cmd>Telescope project<cr>", "Projects" },
            s = { "<cmd>SudaRead<cr>", "Sudo current file" },
            l = { "<cmd>NvimTreeFindFile<cr>", "Locate current file" },
            e = { "<cmd>Oil<cr>", "Edit as Buffer (Oil)" },
        },

        s = {
            name = "+search",
            s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search File" },
            p = { "<cmd>Telescope live_grep<cr>", "Search Project" },
            ["["] = { "<cmd>Telescope resume<cr>", "Resume Search" },
            e = { "<cmd>Telescope symbols<cr>", "Emojis" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Pages" },
            m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            c = { "<cmd>Telescope colorscheme<cr>", "Colourscheme" },
            r = { "<cmd>Telescope registers<cr>", "Registers" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        },

        w = {
            name = "+window",
            h = { "<cmd>vsplit<cr>", "Split Horizontal" },
            v = { "<cmd>split<cr>", "Split Vertical" },
        },

        c = {
            name = "+code",
            a = { vim.lsp.buf.code_action, "Code Action" },
            r = { vim.lsp.buf.rename, "Rename" },
            R = { "<cmd>Telescope lsp_references<cr>", "References" },
            i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols" },
            S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Project Symbols" },
            d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
        },

        g = {
            name = "+git",
            g = { require("neogit").open, "NeoGit" },
            d = { "<cmd>Gitsigns diffthis<cr>", "Diff" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
            S = { "<cmd>Telescope git_stash<cr>", "Stashes" },
            c = { "<cmd>Telescope git_commits<cr>", "Commits" },
            C = { "<cmd>Telescope git_bcommits<cr>", "File Commits" },
            b = { "<cmd>Gitsigns blame_line<cr>", "Blame Line"},
            B = { "<cmd>Telescope git_branches<cr>", "Branches" },
            a = { "<cmd>Gitsigns stage_hunk<cr>", "Stage" },
            u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage" },
            p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview" },
            x = { "<cmd>Gitsigns reset_hunk<cr>", "Discard" },
        },

        o = {
            name = "+open",
            p = { "<cmd>NvimTreeToggle<cr>", "File Tree" },
            t = { "<cmd>ToggleTerm 1 direction=float<cr>", "Terminal Float" },
            T = { "<cmd>ToggleTerm 2 direction=vertical<cr>", "Terminal Bar" },
            l = { "<cmd>LspInfo<cr>", "Lsp Info" },
            n = { "<cmd>Telescope notify<cr>", "Notifications" },
        },

        d = {
            name = "+debug",
            c = { require("dap").continue, "Continue" },
            l = { require("dap").step_over, "Step over" },
            j = { require("dap").step_into, "Step into" },
            k = { require("dap").step_out, "Step out" },
            b = { require("dap").toggle_breakpoint, "Toggle Breakpoint" },
            r = { "<cmd>RustRunnables<cr>", "Runnables" },
            d = { "<cmd>RustDebuggables<cr>", "Debuggables" },
        },

        n = {
            name = "+notes",
            n = {
                function()
                    vim.cmd("e ~/Nextcloud/Vault/Scratch.md")
                    require("telescope.builtin").find_files({
                        find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
                    )
                end,
                "Open Vault"
            },

            c = { "gg/incomplete<cr>Daunchecked<esc>", "Complete Note" },
            C = { "gg/unchecked<cr>2x", "Check Note" },

            l = {
                function()
                    -- Get the current file
                    local path = vim.fn.expand("%")
                    -- Find the position of the last slash
                    local last_slash = path:find("/[^/]*$")
                    -- Get the pos of first space in file name
                    local first_space = last_slash + path:sub(last_slash + 1):find(' ')
                    -- Get the lecture number and add 1
                    local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) + 1
                    -- Add the new lecture number to the path
                    path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

                    open_file(path .. "*")
                end,
                "Next Lecture"
            },
            h = {
                function()
                    -- Get the current file
                    local path = vim.fn.expand("%")
                    -- Find the position of the last slash
                    local last_slash = path:find("/[^/]*$")
                    -- Get the pos of first space in file name
                    local first_space = last_slash + path:sub(last_slash + 1):find(' ')
                    -- Get the lecture number and add 1
                    local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) - 1
                    -- Add the new lecture number to the path
                    path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

                    open_file(path .. "*")
                end,
                "Previous Lecture"
            },
            k = {
                function()
                    -- Get the current file
                    local path = vim.fn.expand("%")
                    -- Find the position of the last slash
                    local last_slash = path:find("/[^/]*$")
                    -- Add the lecture number "00" to the path
                    path = path:sub(0, last_slash + 5) .. "00.md"

                    open_file(path)
                end,
                "This Module"
            },
        },

        z = {
            name = "+spellcheck",
            g = { "zg", "Good word" },
            G = { "zw", "Bad word" },
            l = { "]s", "Next issue" },
            h = { "[s", "Prev issue" },
            z = { "z=", "Correct" },
        },

        [";"] = { require("notify").dismiss, "Dismiss notifications" },

    },
    -- Moving between windows
    ["<C-h>"] = { "<C-w>h", "Go Left" },
    ["<C-l>"] = { "<C-w>l", "Go Right" },
    ["<C-j>"] = { "<C-w>j", "Go Down" },
    ["<C-k>"] = { "<C-w>k", "Go Up" },
    -- Quit the terminal while inside it
    ["<Esc>"] = { "<cmd>ToggleTerm direction=float<cr>", "Quit Terminal", mode = "t" },
})

vim.keymap.set("n", ";", "<cmd>Commentary<cr>", { desc = "Comment" })
vim.keymap.set("v", ";", ":'<,'>Commentary<cr>", { desc = "Comment" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Diagnostic hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Goto type definition" })

-- Makes j and k when line wraps nicer
-- https://www.reddit.com/r/vim/comments/2k4cbr/comment/clhv03p
vim.cmd[[nnoremap <expr> k v:count == 0 ? 'gk' : 'k']]
vim.cmd[[nnoremap <expr> j v:count == 0 ? 'gj' : 'j']]

