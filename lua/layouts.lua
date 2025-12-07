vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        -- Only run layout setup if no files were specified
        if vim.fn.argc() == 0 then
            vim.cmd("NvimTreeOpen")
            vim.cmd("tabnew")
            vim.cmd("LayoutChat")
            vim.cmd("tabprev")
        end
    end,
    once = true,
})

vim.api.nvim_create_user_command("LayoutCode", function()
    vim.cmd("only")
    vim.cmd("enew")
    vim.cmd("NvimTreeOpen")
end, {})

vim.api.nvim_create_user_command("LayoutChat", function()
    vim.cmd("only")
    vim.cmd("terminal claude")
    vim.cmd("NvimTreeOpen")
end, {})
