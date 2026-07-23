-- Visual Studio-style dark theme. vscode.nvim replicates VS Code's "Dark+"
-- palette, which shares Visual Studio's dark editor colors (#1E1E1E bg, blue
-- keywords, teal types, yellow methods). Roslyn's LSP semantic tokens then
-- color C# almost exactly like the Visual Studio editor.
return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false, -- load during startup (it's the main UI)
    priority = 1000, -- before other plugins, so highlights are set first
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      underline_links = true,
      -- color the gutter/number column like the editor background
      disable_nvimtree_bg = true,
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("vscode")
    end,
  },

  -- Cobalt2 (Wes Bos) — downloaded but NOT applied; vscode stays active.
  -- It themes only via colorbuddy (its colors/cobalt2.vim is empty), so plain
  -- `:colorscheme cobalt2` won't work. Instead a `:Cobalt2` command is defined
  -- at startup that loads the plugin on demand and applies it.
  -- colorbuddy uses latest (NOT the README's pinned v1.0.0 — that release has a
  -- Windows bug: it builds Lua module names with backslashes and require() fails.
  -- Latest colorbuddy refactored that code away.
  {
    "lalitmee/cobalt2.nvim",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    lazy = true,
    init = function()
      vim.api.nvim_create_user_command("Cobalt2", function()
        require("lazy").load({ plugins = { "cobalt2.nvim" } })
        require("colorbuddy").colorscheme("cobalt2")
      end, { desc = "Apply the Cobalt2 colorscheme" })
    end,
  },
}
