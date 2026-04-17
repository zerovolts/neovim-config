return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function()
                local gitsigns = require("gitsigns")

                local keymap = vim.keymap
                keymap.set("n", "<leader>hs", gitsigns.stage_hunk)
                keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
                keymap.set("v", "<leader>hs",
                    function() gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
                keymap.set("v", "<leader>hr",
                    function() gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
                keymap.set("n", "<leader>hu", gitsigns.stage_hunk)
                keymap.set("n", "<leader>hd", gitsigns.diffthis)
            end,
        },
    },
}
