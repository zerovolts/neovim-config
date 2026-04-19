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

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
})
