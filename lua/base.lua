local opt = vim.opt
local api = vim.api

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

opt.signcolumn = "yes"

opt.list = true
opt.listchars = {
    leadmultispace = "▏   ",
    tab = "→ ",
}

require("vim._core.ui2").enable()

-- Disable indent markers in terminal buffers (e.g. opencode TUI)
api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    desc = "Disable listchars in terminal buffers",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.opt_local.list = false
        end
    end,
})
vim.opt.fillchars = {
    vert = " ",
    eob = " ",
    diff = "╱",
}

opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "popup" }

opt.termguicolors = true

opt.scrolloff = 8

opt.cursorline = true

opt.showmode = false

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = true,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Render editor char width line
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
    callback = function()
        if vim.bo.buftype == "" then
            lsp.buf.format()
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.vs", "*.fs", "*.vert", "*.frag" },
    callback = function()
        vim.bo.filetype = "glsl"
    end,
})
