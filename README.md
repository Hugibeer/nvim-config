# nvim-config

Personal Neovim configuration — built from scratch on top of
[lazy.nvim](https://github.com/folke/lazy.nvim), not the full LazyVim distro
(the `lazyvim.json` file is just a leftover artifact). Focused on Markdown
writing, C#/.NET development, and a lightweight general editing setup.

## Layout

- `init.lua` — options, keymaps, LSP keymaps/completion (shared across all
  languages via `LspAttach`), and the lazy.nvim bootstrap.
- `lua/plugins/` — one file per plugin/concern, loaded by `require("lazy").setup("plugins")`:
  - `colorscheme.lua` — VS Code–style dark theme (`vscode.nvim`)
  - `dashboard.lua` — start screen (`alpha-nvim`)
  - `explorer.lua` — file tree (`nvim-tree.lua`)
  - `telescope.lua` / `fzf.lua` — fuzzy finding
  - `treesitter.lua` — parser/query installer (highlighting is enabled per-filetype in `init.lua`)
  - `lsp.lua` — Mason + LSP server setup + formatting, shared by all languages
  - `markdown.lua` — Markdown-specific plugins (render-markdown, etc.)
  - `csharp.lua` / `dotnet.lua` / `dap.lua` — C#/.NET via Roslyn, easy-dotnet, and nvim-dap
  - `web.lua` — Angular/TypeScript/Nx tooling
  - `git.lua` — vim-fugitive
  - `trouble.lua` / `which-key.lua` — diagnostics list and keymap popup
- `after/ftplugin/markdown.lua` — Markdown filetype overrides.
- `cheatsheet.md` — personal keymap reference, opened from inside Neovim via
  `<leader>hc` or `:Cheatsheet`.

## Getting started

Pick one of the following.

**Option A — clone directly into the Neovim config dir:**

```bash
git clone <this repo> ~/.config/nvim
nvim
```

**Option B — clone elsewhere and symlink** (useful if you keep all repos
under one folder, e.g. `~/Github`):

```bash
git clone <this repo> ~/Github/nvim-config
ln -s ~/Github/nvim-config ~/.config/nvim
nvim
```

Plugins install automatically on first launch via lazy.nvim. Mason installs
LSP servers/tools (marksman, roslyn, etc.) as needed.

## Keymaps

See [`cheatsheet.md`](./cheatsheet.md) for the full list, or press
`<leader>?` inside Neovim for a live which-key popup scoped to the current
buffer.
