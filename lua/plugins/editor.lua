return {
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
            local api = require("Comment.api")

            -- Ghostty expects `<C-/>` and tmux expects `<C-_>`
            vim.keymap.set("n", "<C-/>", api.toggle.linewise.current)
            vim.keymap.set("n", "<C-_>", api.toggle.linewise.current)

            -- TODO: doesn't work very well for commenting part of a line
            -- Toggle comment on a visual block and keep the selection
            function handler()
                -- Save the current visual selection positions
                local start_line = vim.fn.line("v")
                local end_line = vim.fn.line(".")

                -- Exit visual mode and comment
                local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
                vim.api.nvim_feedkeys(esc, 'nx', false)
                api.toggle.linewise(vim.fn.visualmode())

                -- Restore visual selection
                vim.fn.setpos("'<", { 0, start_line, 1, 0 })
                vim.fn.setpos("'>", { 0, end_line, 999, 0 })

                -- Re-enter visual mode
                vim.cmd('normal! gv')
            end

            vim.keymap.set("v", "<C-/>", handler)
            vim.keymap.set("v", "<C-_>", handler)
        end
    },
}
