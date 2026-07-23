-- which-key: popup panel listing available keybindings after a prefix key
-- (e.g. <leader>/space). Picks up any keymap that has a `desc`.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer keymaps (which-key)",
    },
  },
}
