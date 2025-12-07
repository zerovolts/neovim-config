local colors = require("colors")

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = {
                    normal = {
                        a = { bg = colors.fg, fg = colors.bg },
                        b = { bg = colors.dark, fg = colors.mfg },
                        c = { bg = colors.dark, fg = colors.mfg },
                        x = { bg = colors.dark, fg = colors.mfg },
                        y = { bg = colors.dark, fg = colors.mfg },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                    insert = {
                        a = { bg = colors.red, fg = colors.bg },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                    terminal = {
                        a = { bg = colors.dark, fg = colors.green },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                    visual = {
                        a = { bg = colors.violet, fg = colors.dark },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                    command = {
                        a = { bg = colors.green, fg = colors.dark },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                    replace = {
                        a = { bg = colors.yellow, fg = colors.dark },
                        z = { bg = colors.dark, fg = colors.mfg },
                    },
                },
                sections = {
                    lualine_z = { "location", "lsp_status" }
                },
                icons_enabled = false,
                component_separators = {
                    left = "·",
                    right = "·",
                },
                section_separators = {
                    left = "",
                    right = "",
                },
            },
        },
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        opts = {
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            renderer = {
                icons = {
                    git_placement = "after",
                    glyphs = {
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                        },
                        git = {
                            unstaged = "×",
                            staged = "",
                            unmerged = "",
                            untracked = "?",
                            renamed = "",
                            deleted = "",
                            ignored = "∅",
                        },
                    },
                },
            },
        },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>" },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
        },
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble" },
        }
    },

    {
        "akinsho/toggleterm.nvim",
        config = true,
        keys = {
            { "<C-j>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
        },
    },

}
