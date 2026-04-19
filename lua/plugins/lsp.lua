-- Non-LSP tools (formatters/linters) to auto-install via Mason
local tools = { "stylua", "selene", "black", "ruff" }

-- Each of these LSP servers gets auto-installed along with the Treesitter grammar.
-- They still need to be configured in `setup_language_servers`.
local lsp_servers = {
    lua = "lua-language-server",
    python = "basedpyright",
    typescript = "typescript-language-server",
    html = "html-lsp",
    css = "css-lsp",
    zig = "zls",
    c = "clangd",
    go = "gopls",
}

local function setup_language_servers(lsp_capabilities)
    -- The config keys can be anything, but we're passing in the lsp server
    -- name so that we can make use of it in lualine.
    vim.lsp.config[lsp_servers["lua"]] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
        capabilities = lsp_capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            },
        },
    }

    vim.lsp.config[lsp_servers["go"]] = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["c"]] = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["zig"]] = {
        cmd = { "zls" },
        filetypes = { "zig" },
        root_markers = { "build.zig", "build.zig.zon", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["html"]] = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        root_markers = { "package.json", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["css"]] = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["typescript"]] = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_markers = { "tsconfig.json", "package.json", ".git" },
        capabilities = lsp_capabilities,
    }

    vim.lsp.config[lsp_servers["python"]] = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        capabilities = lsp_capabilities,
    }

    for _, server_name in pairs(lsp_servers) do
        vim.lsp.enable(server_name)
    end
end

local config = {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
            local registry = require("mason-registry")
            -- Auto-install servers defined in `lsp_servers`
            registry.refresh(function()
                for _, name in pairs(lsp_servers) do
                    local ok, pkg = pcall(registry.get_package, name)
                    if ok and not pkg:is_installed() then
                        pkg:install()
                    end
                end
                for _, name in ipairs(tools) do
                    local ok, pkg = pcall(registry.get_package, name)
                    if ok and not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)
        end,
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
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
            })

            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            setup_language_servers(lsp_capabilities)
        end,
    },

    {
        -- Lightweight plugin for installing Treesitter parsers
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup({
                ensure_installed = vim.list_extend(vim.tbl_keys(lsp_servers), { "javascript", "tsx", "markdown" }),
            })
        end,
    },
}

return config
