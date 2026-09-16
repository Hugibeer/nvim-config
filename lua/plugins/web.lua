-- Angular/TypeScript/Nx stack (web-workspace). LSP servers themselves are
-- installed via mason-lspconfig in lsp.lua and use their nvim-lspconfig
-- bundled defaults unchanged — angularls already root-detects Nx workspaces
-- (nx.json, no angular.json needed) and eslint/stylelint_lsp already
-- root-detect via package-lock.json, so no custom server config is needed
-- here. This file covers everything else: template filetype detection,
-- fix-all keymaps, JSON schemas, and test running.

-- Angular component templates (*.component.html) get their own filetype so
-- treesitter picks the "angular" parser (adds `@if`/`@for`/`@switch` block
-- syntax on top of html) and angularls/eslint/emmet attach with Angular-
-- aware behavior instead of being treated as plain html.
vim.filetype.add({
  pattern = {
    [".*%.component%.html"] = "htmlangular",
  },
})

-- mason installs bmatcuk's stylelint-lsp (binary `stylelint-lsp`, command
-- `stylelint.applyAutoFixes`), not the official stylelint-language-server
-- nvim-lspconfig's bundled default assumes (binary `stylelint-language-server`,
-- command `stylelint.applyAutoFix`) — override both to match what's installed.
vim.lsp.config("stylelint_lsp", {
  cmd = { "stylelint-lsp", "--stdio" },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspStylelintFixAll", function()
      client:request_sync("workspace/executeCommand", {
        command = "stylelint.applyAutoFixes",
        arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
      }, nil, bufnr)
    end, {})
  end,
})

-- ESLint/Stylelint "fix all" commands are registered per-buffer by their LSP
-- (see nvim-lspconfig's lsp/eslint.lua, lsp/stylelint_lsp.lua) once attached.
-- Wire them to a keymap next to conform's <leader>cf (lsp.lua), kept manual
-- rather than on-save since fixes run against the whole file.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client.name == "eslint" then
      vim.keymap.set("n", "<leader>cl", "<cmd>LspEslintFixAll<cr>", { buffer = args.buf, desc = "ESLint: fix all" })
    elseif client.name == "stylelint_lsp" then
      vim.keymap.set(
        "n",
        "<leader>cl",
        "<cmd>LspStylelintFixAll<cr>",
        { buffer = args.buf, desc = "Stylelint: fix all" }
      )
    end
  end,
})

return {
  -- JSON schema validation/completion for project.json, nx.json,
  -- tsconfig*.json, package.json via the jsonls already enabled in lsp.lua.
  -- Loaded eagerly (not ft-gated) so vim.lsp.config runs before jsonls ever
  -- attaches to a buffer.
  {
    "b0o/schemastore.nvim",
    config = function()
      vim.lsp.config("jsonls", {
        settings = {
          json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
        },
      })
    end,
  },

  -- Auto-close/rename matching tags in .html templates as you edit (needs
  -- the html/angular treesitter parsers installed in treesitter.lua).
  { "windwp/nvim-ts-autotag", ft = { "html", "htmlangular" }, opts = {} },

  -- Inline test running for Vitest specs (this repo uses vitest only, no
  -- jest/karma). Each Nx app/lib has its own vite.config.mts, which
  -- neotest-vitest resolves relative to the spec file being run.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "marilari88/neotest-vitest",
    },
    keys = {
      -- <leader>tn, not <leader>tt: easy-dotnet.nvim (dotnet.lua) already owns
      -- <leader>tt for its .NET test runner; both `keys` specs are global, so
      -- whichever loaded last would silently steal the mapping.
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      {
        "<leader>tf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Test: run file",
      },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: show output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
    },
    opts = function()
      return { adapters = { require("neotest-vitest") } }
    end,
  },
}
