# Neovim Config — Agent Guidelines

This is a personal Neovim configuration written in Lua, managed with **vim.pack** (Neovim's built-in package manager).

---

## Repository Structure

```
~/.config/nvim/
├── init.lua              # Entry point — requires base, keymap, pack, setup
├── colors/
│   └── elemental.lua     # Custom colorscheme definition
└── lua/
    ├── base.lua          # vim.opt settings, autocmds, global state
    ├── keymap.lua        # Global keymaps + LspAttach buffer keymaps
    ├── colors.lua        # Exported color palette table
    ├── pack.lua          # Plugin list (vim.pack.add)
    └── setup.lua         # Plugin setup calls (LSP, treesitter, lualine, oil, etc.)
```

---

## Documentation Maintenance

**After any change that adds, removes, or rebinds a keymap, adds or removes a plugin, or alters
repo structure — update both of these files before finishing:**

- `AGENTS.md` — repo structure, conventions, any new patterns introduced
- `cheatsheet.md` — keymaps (add new ones, remove old ones, keep sections accurate)

---

## Build / Lint / Test Commands

There is no build system, test framework, or linter config in this repo. No Makefile,
package.json, or scripts directory exists.

**Runtime validation** (inside Neovim):
- `:checkhealth` — diagnose plugin/LSP/runtime issues
- `:messages` — review recent Neovim messages/errors

**External tooling:**
- `stylua` — Lua formatter (configured via `conform.nvim`)
- `selene` — Lua linter (configured via `nvim-lint`)

To validate changes, restart Neovim and check `:messages` / `:checkhealth`.

---

## Code Style

### Indentation and Formatting

- **4 spaces** — no tabs. Matches `opt.tabstop = 4` / `opt.shiftwidth = 4` in `base.lua`.
- Trailing commas on the last entry of multi-line tables.
- Inline alignment is acceptable for readability in short tables:
  ```lua
  { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
  { out,                            "WarningMsg" },
  ```
- Keep lines under ~100 characters where reasonable.

### Naming Conventions

- **snake_case** for all local variables and functions: `lsp_capabilities`, `start_line`, `setup_language_servers`.
- **PascalCase** only when required by external plugin APIs (e.g., `require("Comment")`).
- Module names match their filename: `require("colors")` → `lua/colors.lua`.
- Avoid global variables. The one exception in the current codebase (`setup_language_servers` in `lsp.lua`) is a known issue — prefer `local` always.

### Imports / Require

- Alias commonly used vim namespaces at the top of each file:
  ```lua
  local opt = vim.opt
  local api = vim.api
  local keymap = vim.keymap
  ```
- Place `require()` calls inside `config = function()` blocks for plugin-scoped dependencies
  (keeps them lazy-loaded and avoids top-level errors if a plugin isn't installed):
  ```lua
  config = function()
      local cmp = require("cmp")
      cmp.setup({ ... })
  end
  ```
- Top-level `require` is fine for local modules (`require("colors")`) and for files that
  are always loaded (e.g., `base.lua`, `keymap.lua`).

### Plugin Configuration

Plugins are listed in `pack.lua` via `vim.pack.add(...)` and configured in `setup.lua` via
`require("plugin").setup({ ... })`. Keep the two concerns separate — `pack.lua` is the
manifest, `setup.lua` is the configuration.

### Keymaps

Two patterns are used depending on scope:

1. **Global keymaps** — defined in `keymap.lua` using `vim.keymap.set`:
   ```lua
   keymap.set("i", "jk", "<Esc>")
   keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })
   ```

2. **Buffer-local LSP keymaps** — defined inside an `LspAttach` autocmd in `keymap.lua`:
   ```lua
   vim.api.nvim_create_autocmd("LspAttach", {
       desc = "LSP actions",
       callback = function(event)
           local opts = { buffer = event.buf }
           vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
       end,
   })
   ```

### Autocommands

All autocommands use `vim.api.nvim_create_autocmd`. Guidelines:

- Always provide a `desc` for clarity.
- Use `group` (via `nvim_create_augroup` with `{ clear = true }`) when the autocmd may be
  re-sourced to avoid duplicates:
  ```lua
  api.nvim_create_autocmd("BufWritePre", {
      group = api.nvim_create_augroup("LspFormatting", { clear = true }),
      callback = function() vim.lsp.buf.format() end,
  })
  ```
- Use `once = true` for one-shot event handlers (e.g., `LazyDone`).

### LSP Configuration

This config uses **Neovim 0.11+ native LSP API** (`vim.lsp.config`, `vim.lsp.enable`) —
**not** the `lspconfig` plugin. Follow this pattern when adding new language servers:

```lua
vim.lsp.config("server_name", {
    cmd = { "server-binary" },
    filetypes = { "filetype" },
    root_markers = { "marker_file" },
    settings = { ... },
})
vim.lsp.enable("server_name")
```

Mason is installed as a manual installer UI only (no mason-lspconfig bridge).

### Error Handling

- No pcall/xpcall is used in this config — keep that consistent unless wrapping genuinely
  fallible operations (e.g., optional plugin requires).
- For critical bootstrap failures (like the lazy.nvim clone), use `nvim_echo` with
  `"ErrorMsg"` highlight and `os.exit(1)`:
  ```lua
  if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
  end
  ```

### Colors

The color palette lives in `lua/colors.lua` and is exported as a plain table:
```lua
-- lua/colors.lua
return {
    bg = "#...",
    fg = "#...",
    ...
}
```
Import it with `local colors = require("colors")`. When adding new color keys, add them to
this file — do not hardcode hex values inline in plugin configs.

---

## Key Conventions Summary

| Concern | Convention |
|---|---|
| Indentation | 4 spaces |
| Variable naming | snake_case |
| Globals | Avoid — use `local` always |
| Plugin manifest | `lua/pack.lua` via `vim.pack.add` |
| Plugin setup | `lua/setup.lua` via `require(...).setup(...)` |
| Keymaps (global) | `lua/keymap.lua` via `vim.keymap.set` |
| Keymaps (LSP) | `LspAttach` autocmd in `keymap.lua` |
| Autocommands | `nvim_create_autocmd` with `desc` |
| LSP servers | Native 0.11+ API (`vim.lsp.config` + `vim.lsp.enable`) |
| Colors | Define in `lua/colors.lua`, import via `require("colors")` |
| Docs | Update `AGENTS.md` + `cheatsheet.md` after keymap/plugin/structure changes |
