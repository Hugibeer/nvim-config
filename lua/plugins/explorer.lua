-- File explorer sidebar via nvim-tree, on the same keys LazyVim used:
-- <leader>e toggles the tree, <leader>E toggles it revealing the current file.
-- Chosen over neo-tree/snacks for the minimal dependency footprint that fits
-- this config (only nvim-web-devicons, which needs a Nerd Font for icons).
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer (toggle)" },
      { "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer (reveal current file)" },
    },
    init = function()
      -- plugin is lazy-loaded, so it can't hijack `nvim <dir>` unless we
      -- load it up front when the startup argument is a directory
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("lazy").load({ plugins = { "nvim-tree.lua" } })
        end
      end
    end,
    opts = {
      -- netrw stays loaded (:Ex works), but opening a directory
      -- (`nvim <dir>`, `:e <dir>`) shows the tree instead of netrw
      disable_netrw = false,
      hijack_netrw = true,
      -- show git-ignored files (LocalOnly/ etc.); `I` in the tree toggles this
      git = { ignore = false },
      sync_root_with_cwd = true,
      view = { width = 34 },
      renderer = { group_empty = true },
    },
  },
}
