local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.autoread = true

opt.incsearch = true

opt.signcolumn = 'yes'

opt.list = true
opt.listchars = {
    space = "·",
    multispace = "   ▹",
}

opt.termguicolors = true

opt.scrolloff = 8

opt.cursorline = true

-- Render editor char width line
local api = vim.api
local bo = vim.bo
api.nvim_create_autocmd("FileType", {
    callback = function()
        if bo.filetype == "rust" then
            -- Rust standard is 100 chars
            opt.colorcolumn = "100"
        else
            opt.colorcolumn = "80"
        end
    end,
})

-- Format on save
local lsp = vim.lsp
api.nvim_create_autocmd("BufWritePre", {
    group = api.nvim_create_augroup("LspFormatting", { clear = true }),
    buffer = bufnr,
    callback = function()
        lsp.buf.format()
    end
})

vim.g.mapleader = " "

local keymap = vim.keymap

-- Tap j and k simultaneously to exit interactive mode
keymap.set("i", "jk", "<Esc>")
keymap.set("i", "kj", "<Esc>")

-- Turn off current search highlighting on <Esc>
keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })

-- Centered Movement
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
