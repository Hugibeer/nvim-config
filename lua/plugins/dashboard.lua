-- Start screen via alpha-nvim (startify theme). Shows on `nvim` with no args:
-- recent files (global + cwd) as numbered shortcuts, plus a few buttons.
-- The startify theme lists MRU files natively — no telescope/fzf needed,
-- which this config doesn't have.
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local startify = require("alpha.themes.startify")

      startify.section.top_buttons.val = {
        startify.button("e", "New file", "<cmd>enew | startinsert<cr>"),
        startify.button("f", "File explorer", "<cmd>NvimTreeToggle<cr>"),
        startify.button("c", "Cheatsheet", "<cmd>edit " .. vim.fn.stdpath("config") .. "/cheatsheet.md<cr>"),
        startify.button("l", "Lazy (plugins)", "<cmd>Lazy<cr>"),
        startify.button("m", "Mason (LSP tools)", "<cmd>Mason<cr>"),
      }

      require("alpha").setup(startify.config)
    end,
  },
}
