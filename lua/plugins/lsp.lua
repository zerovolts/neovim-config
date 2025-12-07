local config = {
    {
        "williamboman/mason.nvim",
        config = true,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                },
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
            })

            setup_language_servers()
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "zig", "markdown", "vim", "vimdoc" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    {
        -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        "maan2003/lsp_lines.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({
                virtual_text = false,
            })
        end,
    }
}

function setup_language_servers()
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config["lua"] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
        capabilities = lsp_capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT"
                },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            },
        },
    }
    vim.lsp.enable("lua")

    vim.lsp.config["zig"] = {
        cmd = { "zls" },
        filetypes = { "zig" },
        root_markers = { "build.zig", "build.zig.zon", ".git" },
        capabilities = lsp_capabilities,
    }
    vim.lsp.enable("zig")

    vim.lsp.config["python"] = {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_markers = { ".git" },
        capabilities = lsp_capabilities,
    }
    vim.lsp.enable("python")
end

return config
