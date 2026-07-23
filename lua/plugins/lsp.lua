-- Shared LSP + Mason + formatting, used by all languages.
-- LSP keymaps + native completion live in init.lua (global LspAttach autocmd).

return {
  -- LSP server definitions + mason. mason-lspconfig auto-enables installed
  -- servers via vim.lsp.enable. marksman = markdown LSP. (C# uses roslyn.nvim,
  -- which manages its own client — see csharp.lua.)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = { "marksman" } } },
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
      formatters_by_ft = { markdown = { "markdownlint-cli2", "markdown-toc" } },
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
