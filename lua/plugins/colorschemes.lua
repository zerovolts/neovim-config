return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup()
        end,
    },

    {
        "neanias/everforest-nvim",
        priority = 1000,
        config = function()
            require("everforest").setup({
                background = "hard",
            })
        end,
    },

    {
        "Shatur/neovim-ayu",
        priority = 1000,
        config = function()
            require("ayu").setup({
                mirage = true,
            })
        end,
    },

    -- Adds background color to hex values
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
}
