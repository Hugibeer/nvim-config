-- C# / .NET via the Roslyn language server (roslyn.nvim).
-- Far faster and more capable than OmniSharp; provides completion, navigation,
-- diagnostics, code actions, and semantic-token highlighting. The server binary
-- ("roslyn") is installed by mason-tool-installer in lsp.lua; roslyn.nvim
-- auto-detects the mason install and manages the LSP client itself.
--
-- No nvim-treesitter for C# (it would reintroduce the markdown parser conflict
-- on nvim 0.12). Highlighting comes from Roslyn semantic tokens + Vim's bundled
-- cs syntax. Shared LSP keymaps come from the global LspAttach autocmd in init.lua.

return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    opts = {},
  },
}
