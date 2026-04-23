local function gh(str)
    return "https://github.com/" .. str
end

vim.pack.add({
    -- Package manager for LSP servers, linters, and formatters
    gh("williamboman/mason.nvim"),
    -- Package manager for Treesitter parsers
    gh("romus204/tree-sitter-manager.nvim"),

    -- Fuzzy finder
    gh("nvim-telescope/telescope.nvim"),
    -- Library of utility functions (dependency of telescope.nvim)
    gh("nvim-lua/plenary.nvim"),

    -- Formatter runner (requires formatters through mason.nvim)
    gh("stevearc/conform.nvim"),
    -- Linter runner (requires linters through mason.nvim)
    gh("mfussenegger/nvim-lint"),

    -- Color highlighter
    gh("norcalli/nvim-colorizer.lua"),

    -- Status line
    gh("nvim-lualine/lualine.nvim"),

    -- File explorer
    gh("stevearc/oil.nvim"),

    -- Diagnostic list
    gh("folke/trouble.nvim"),

    -- Git actions and sign-column information
    gh("lewis6991/gitsigns.nvim"),
    -- Side-by-side diff view
    gh("sindrets/diffview.nvim"),

    -- Terminal tray
    gh("akinsho/toggleterm.nvim"),

    -- Love2D game runner
    gh("S1M0N38/love2d.nvim"),

    -- Color schemes
    gh("ellisonleao/gruvbox.nvim"),
    gh("neanias/everforest-nvim"),
    gh("Shatur/neovim-ayu"),

    -- Icons used as a dependency for various plugins
    gh("nvim-tree/nvim-web-devicons"),
}, { load = true })
