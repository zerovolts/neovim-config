local colors = require("colors")

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = {
                    normal = {
                        a = { bg = colors.gray7, fg = colors.gray0 },
                        b = { bg = colors.gray3, fg = colors.gray7 },
                        c = { bg = colors.gray2, fg = colors.gray7 },
                    },
                    insert = {
                        a = { bg = colors.red, fg = colors.gray0 },
                    },
                    terminal = {
                        a = { bg = colors.dark, fg = colors.green },
                    },
                    visual = {
                        a = { bg = colors.blue, fg = colors.gray0 },
                    },
                    command = {
                        a = { bg = colors.green, fg = colors.gray0 },
                    },
                    replace = {
                        a = { bg = colors.yellow, fg = colors.gray0 },
                    },
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
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { "filename" },
                lualine_x = { "filetype" },
                lualine_y = {
                    -- LSP
                    function()
                        local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                        if #clients == 0 then
                            return "lsp(×)"
                        end
                        return "lsp("
                            .. table.concat(
                                vim.tbl_map(function(c)
                                    return c.name
                                end, clients),
                                ", "
                            )
                            .. ")"
                    end,
                    -- Treesitter
                    function()
                        if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
                            return "ts(✓)"
                        end
                        return "ts(×)"
                    end,
                },
                lualine_z = { "location" },
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
        },
    },

    {
        "akinsho/toggleterm.nvim",
        config = true,
        keys = {
            { "<C-j>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
        },
    },
}
