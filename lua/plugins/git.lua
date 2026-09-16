-- Git integration via vim-fugitive: :Git <any git command>, plus a blame
-- column (annotate) mapped below.
return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gclog", "Gvdiffsplit" },
    keys = {
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame (annotate)" },
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
    },
  },
}
