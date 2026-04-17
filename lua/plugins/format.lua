return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters = {
                    black = {
                        prepend_args = { "--fast" },
                    },
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })

            -- Override the LSP format keymap to use conform (with LSP fallback)
            vim.keymap.set({ "n", "x" }, "<F3>", function()
                require("conform").format({ async = true, lsp_fallback = true })
            end)
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            require("lint").linters_by_ft = {
                lua = { "selene" },
                python = { "ruff" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                callback = function()
                    local lint = require("lint")
                    local available = vim.tbl_filter(function(name)
                        local linter = lint.linters[name]
                        return linter and vim.fn.executable(linter.cmd) == 1
                    end, lint.linters_by_ft[vim.bo.filetype] or {})
                    if #available > 0 then
                        lint.try_lint(available)
                    end
                end,
            })
        end,
    },
}
