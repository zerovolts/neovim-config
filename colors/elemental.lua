local colors = require("colors")

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "elemental"

local group = {
    default = { fg = colors.gray7, bg = colors.gray1 },
    -- fire (red) -> change
    fn = { fg = colors.red },
    -- water (blue) -> shape
    type = { fg = colors.blue },
    -- air (yellow) -> vital, ambient
    keyword = { fg = colors.yellow },
    -- earth (green) -> concrete, tangible
    literal = { fg = colors.green },
    punctuation = { fg = colors.gray6 },
    comment = { fg = colors.gray6, bg = colors.gray0 },
    doc_comment = { fg = colors.gray1, bg = colors.gray7 },
    cursor = { fg = colors.gray1, bg = colors.yellow },
}

local function hl(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
end

-- Reset colors
for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
end

vim.opt.guicursor = {
    "n-v-c:block-Cursor", -- Normal/Visual/Command: block with Cursor colors
    "i-ci-ve:ver25-Cursor", -- Insert: vertical bar with iCursor colors
    "r-cr:hor25-Cursor", -- Replace: horizontal bar with rCursor colors
}

hl("Normal", group.default)
hl("Number", group.literal)
hl("Statement", group.keyword)
hl("Type", group.type)
hl("String", group.literal)
hl("Comment", group.comment)
hl("Whitespace", { fg = colors.gray4 })
hl("Function", group.fn)

hl("LineNr", { fg = colors.gray4 })
hl("CursorLineNr", { fg = colors.red })
hl("CursorLine", { bg = colors.gray2 })
hl("Visual", { bg = colors.gray3 })
hl("Cursor", group.cursor)
hl("WinSeparator", { bg = colors.gray0 })
-- hl("MsgArea", { fg = colors.gray7, bg = colors.gray1 })

-- Plugins
hl("StatusLine", { bg = colors.gray3 })
hl("NormalFloat", { bg = colors.gray3 })
hl("NvimTreeNormal", { fg = colors.gray7, bg = colors.gray0 })

-- Diagnostics
hl("DiagnosticVirtualLinesError", { fg = colors.red, bg = colors.gray3 })
hl("DiagnosticVirtualLinesWarn", { fg = colors.yellow, bg = colors.gray3 })
hl("DiagnosticVirtualLinesInfo", { fg = colors.blue, bg = colors.gray3 })
hl("DiagnosticVirtualLinesHint", { fg = colors.green, bg = colors.gray3 })

-- nvim-cmp
do
    hl("Pmenu", { bg = colors.gray3 })
    hl("PmenuSel", { bg = colors.gray4 })
    hl("PmenuSbar", { bg = colors.gray0 })
    hl("PmenuThumb", { bg = colors.gray5 })

    hl("CmpItemKindVariable", { fg = colors.gray7 })
    hl("CmpItemKindFunction", group.fn)
    hl("CmpItemKindMethod", group.fn)
    hl("CmpItemKindKeyword", group.keyword)
    hl("CmpItemKindClass", group.type)
    hl("CmpItemKindModule", group.type)
    hl("CmpItemKindStruct", group.type)
end

------------------------------
--- Treesitter definitions ---
------------------------------

hl("@boolean", group.literal)
hl("@string", group.literal)
hl("@number", group.literal)
hl("@number.float", group.literal)

hl("@operator", group.fn)
hl("@function", group.fn)
hl("@function.builtin", group.fn)
-- referencing a struct's function definition
hl("@lsp.type.function", group.fn)

hl("@keyword", group.keyword)

hl("@type", group.type)
hl("@type.builtin", group.type)
hl("@lsp.type.namespace", group.type)
hl("@constant.builtin", group.type)

hl("@comment", group.comment)
hl("@comment.documentation", group.doc_comment)
hl("@lsp.mod.documentation", group.doc_comment)

hl("@punctuation", group.punctuation)

hl("@markup.heading", group.fn)
hl("@markup.list", group.fn)
hl("@markup.raw.block", { bg = colors.gray0 })
