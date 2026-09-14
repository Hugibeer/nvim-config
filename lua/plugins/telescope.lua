-- Fuzzy finder: find files by name, grep across the project, browse buffers
-- and help tags. Uses telescope-fzf-native for a faster sorter (needs a C
-- compiler to build; WinLibs gcc is on this machine).
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files no_ignore=true<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep additional_args=--no-ignore<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "%.telescope/" },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
