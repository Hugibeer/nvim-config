-- Shared LSP + Mason + formatting, used by all languages.
-- LSP keymaps + native completion live in init.lua (global LspAttach autocmd).

return {
  -- LSP server definitions + mason. mason-lspconfig auto-enables installed
  -- servers via vim.lsp.enable. marksman = markdown LSP, jsonls = JSON
  -- LSP/formatter. (C# uses roslyn.nvim,
  -- which manages its own client — see csharp.lua. Angular/TS/SCSS servers
  -- are listed here too, but configured in web.lua — their bundled
  -- nvim-lspconfig defaults already handle Nx monorepo root detection.)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {
            "marksman",
            "jsonls",
            "angularls",
            "eslint",
            "stylelint_lsp",
            "somesass_ls",
            "emmet_language_server",
          },
          -- automatic_enable (default: on) auto-enables an LSP for ANY
          -- installed mason package that maps to one, not just the ones
          -- listed above — including "roslyn-language-server", installed
          -- below purely as the binary roslyn.nvim's own client shells out
          -- to. Without this exclude, mason-lspconfig ALSO auto-enables its
          -- own bundled "roslyn_ls" server on top of roslyn.nvim's "roslyn"
          -- client: two independent C# LSPs attach to every buffer, so
          -- every go-to-definition/references result comes back doubled.
          automatic_enable = { exclude = { "roslyn_ls" } },
        },
      },
    },
  },

  -- Auto-install CLI tools and language servers not handled by mason-lspconfig:
  --   markdownlint-cli2 = markdown lint, markdown-toc = TOC formatter,
  --   roslyn = C# language server (consumed by roslyn.nvim in csharp.lua).
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "markdownlint-cli2",
        "markdown-toc",
        "roslyn-language-server",
        "netcoredbg", -- .NET debug adapter (used by nvim-dap, see dap.lua)
      },
    },
  },

  -- General formatter. Uses configured formatters where defined, else falls
  -- back to the attached LSP (so C# formats via roslyn, markdown via its tools).
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint-cli2", "markdown-toc" },
        -- Angular/TS project (web-workspace): all read the local .prettierrc
        -- (prettier-plugin-organize-attributes, sorted imports, etc.) via
        -- conform's node_modules-aware prettier formatter.
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        htmlangular = { "prettier" }, -- Angular component templates, see web.lua
        scss = { "prettier" },
        json = { "prettier" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
  },
}
