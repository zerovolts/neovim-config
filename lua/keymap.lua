local keymap = vim.keymap

-- Tap j and k simultaneously to exit interactive mode
keymap.set("i", "jk", "<Esc>")
keymap.set("i", "kj", "<Esc>")

-- Turn off current search highlighting on <Esc>
keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })

-- Centered Movement
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Exit terminal mode
keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Arrow keys to switch panes
keymap.set("n", "<up>", "<C-w><up>")
keymap.set("n", "<down>", "<C-w><down>")
keymap.set("n", "<left>", "<C-w><left>")
keymap.set("n", "<right>", "<C-w><right>")

-- Indent and retain selection
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")

keymap.set("n", "<leader>n", "<cmd>bnext<cr>")
keymap.set("n", "<leader>p", "<cmd>bprev<cr>")

keymap.set("n", "<C-q>", "<cmd>source $MYVIMRC<cr>")

-- Ghostty expects `<C-/>` and tmux expects `<C-_>`
keymap.set("n", "<C-/>", "gcc", { remap = true })
keymap.set("n", "<C-_>", "gcc", { remap = true })
keymap.set("v", "<C-/>", "gc gv", { remap = true })
keymap.set("v", "<C-_>", "gc gv", { remap = true })

-- Allow Enter key for selecting a completion option
vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true })

-- Oil
keymap.set("n", "<leader>e", "<cmd>Oil<cr>")

-- Diffview
keymap.set("n", "<leader>d", function()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end)

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Trouble
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Trouble" })

-- ToggleTerm
keymap.set({ "n", "t" }, "<C-j>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })

-- Love2D (lua files only)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        keymap.set("n", "<leader>vv", "<cmd>LoveRun<cr>", { buffer = true, desc = "Run LÖVE" })
        keymap.set("n", "<leader>vs", "<cmd>LoveStop<cr>", { buffer = true, desc = "Stop LÖVE" })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        -- Set up vim.lsp.completion menu
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
            vim.api.nvim_create_autocmd("TextChangedI", {
                buffer = event.buf,
                callback = function()
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    if col == 0 then
                        return
                    end
                    local line = vim.api.nvim_get_current_line()
                    if line:sub(col, col):match("[%w_%.]") then
                        vim.schedule(function()
                            local keys = vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true)
                            vim.api.nvim_feedkeys(keys, "n", false)
                        end)
                    end
                end,
            })
        end

        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
})
