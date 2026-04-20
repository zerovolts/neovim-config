-- Non-LSP tools (formatters/linters) to auto-install via Mason
local tools = { "stylua", "selene", "black", "ruff" }

-- Each of these LSP servers gets auto-installed along with the Treesitter grammar.
-- They still need to be configured below.
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

require("mason").setup()
local registry = require("mason-registry")
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

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config[lsp_servers["lua"]] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    capabilities = lsp_capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
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

require("tree-sitter-manager").setup({
    ensure_installed = vim.list_extend(vim.tbl_keys(lsp_servers), { "javascript", "tsx", "markdown" }),
})

require("gitsigns").setup({
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
        keymap.set("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        keymap.set("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        keymap.set("n", "<leader>hu", gitsigns.stage_hunk)
        keymap.set("n", "<leader>hd", gitsigns.diffthis)
    end,
})

require("gruvbox").setup()
require("everforest").setup({ background = "hard" })
require("ayu").setup({ mirage = true })
require("colorizer").setup()

local colors = require("colors")

require("lualine").setup({
    options = {
        theme = {
            normal = {
                a = { bg = colors.gray7, fg = colors.gray0 },
                b = { bg = colors.gray3, fg = colors.gray7 },
                c = { bg = colors.gray2, fg = colors.gray7 },
            },
            insert = { a = { bg = colors.red, fg = colors.gray0 } },
            terminal = { a = { bg = colors.dark, fg = colors.green } },
            visual = { a = { bg = colors.blue, fg = colors.gray0 } },
            command = { a = { bg = colors.green, fg = colors.gray0 } },
            replace = { a = { bg = colors.yellow, fg = colors.gray0 } },
        },
        icons_enabled = false,
        component_separators = { left = "·", right = "·" },
        section_separators = { left = "", right = "" },
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
            -- Formatter
            function()
                local ok, conform = pcall(require, "conform")
                if not ok then
                    return ""
                end
                local formatters = vim.tbl_map(function(f)
                    return f.name
                end, conform.list_formatters(vim.api.nvim_get_current_buf()))
                if #formatters == 0 then
                    return "fmt(×)"
                end
                return "fmt(" .. table.concat(formatters, ", ") .. ")"
            end,
            -- Linter
            function()
                local ok, lint = pcall(require, "lint")
                if not ok then
                    return ""
                end
                local linters = vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    return linter and vim.fn.executable(linter.cmd) == 1
                end, lint.linters_by_ft[vim.bo.filetype] or {})
                if #linters == 0 then
                    return "lint(×)"
                end
                return "lint(" .. table.concat(linters, ", ") .. ")"
            end,
        },
        lualine_z = { "location" },
    },
})

require("nvim-tree").setup({
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
                    default = "",
                    open = "",
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
})

require("trouble").setup()
require("toggleterm").setup()

require("conform").setup({
    formatters = {
        black = { prepend_args = { "--fast" } },
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

require("love2d").setup()

require("diffview").setup({ enhanced_diff_hl = true })
