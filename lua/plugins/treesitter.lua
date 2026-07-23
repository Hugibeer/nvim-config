-- Parser/query installer only (main branch). Highlighting itself is enabled
-- by the FileType autocmd in init.lua via vim.treesitter.start().
-- Bundled 0.12 parsers cover no fenced languages beyond c/lua; install the
-- ones we use in markdown code blocks. markdown + markdown_inline are
-- reinstalled so parser versions match this plugin's queries (which shadow
-- the bundled ones in the runtimepath).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    init = function()
      -- tree-sitter CLI defaults to MSVC's cl.exe on Windows; compile with
      -- the WinLibs gcc instead (no MSVC on this machine).
      vim.env.CC = vim.env.CC or "gcc"
    end,
  },
}
