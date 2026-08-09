-- Markdown-specific plugins. Shared LSP/Mason/formatting live in lsp.lua;
-- the marksman LSP and markdownlint/markdown-toc tools are installed there.

return {
  -- NOTE: treesitter highlighting is enabled via a FileType autocmd in
  -- init.lua. Parsers for fenced code-block languages (sql, c_sharp, ...)
  -- are installed by nvim-treesitter (main branch) in treesitter.lua; that
  -- plugin's queries shadow the bundled 0.12 ones, so markdown +
  -- markdown_inline parsers are installed through it too, keeping parser
  -- and query versions matched.

  -- Linting via markdownlint-cli2 (installed by mason-tool-installer in lsp.lua)
  {
    "mfussenegger/nvim-lint",
    ft = { "markdown" },
    config = function()
      require("lint").linters_by_ft = { markdown = { "markdownlint-cli2" } }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        pattern = "*.md",
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
  },
  -- Browser live preview: Mermaid diagrams, LaTeX (KaTeX), scroll sync, no npm
  {
    "selimacerbas/markdown-preview.nvim",
    ft = { "markdown" },
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        instance_mode = "takeover", -- one shared browser tab
        port = 0, -- auto
        open_browser = true,
        default_theme = "dark",
        debounce_ms = 300,
      })
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown preview start" },
      { "<leader>mS", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown preview stop" },
      { "<leader>mr", "<cmd>MarkdownPreviewRefresh<cr>", desc = "Markdown preview refresh" },
    },
  },
}
