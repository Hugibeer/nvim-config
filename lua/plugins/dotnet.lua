-- .NET test runner + run/build helpers via easy-dotnet.nvim.
-- Chosen over neotest-dotnet because neotest requires nvim-treesitter + the
-- c_sharp parser, which would reintroduce the markdown highlighting conflict on
-- nvim 0.12. easy-dotnet uses the dotnet CLI for discovery and integrates with
-- the netcoredbg adapter already configured in dap.lua, so individual tests can
-- be run or debugged. It also auto-resolves the DLL path for debugging.
return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Dotnet" },
    ft = { "cs" },
    -- easy-dotnet ships its own bundled Roslyn LSP (lsp.enabled defaults to
    -- true), but C# LSP here is handled by seblyng/roslyn.nvim (see csharp.lua).
    -- Leaving it on starts a SECOND Roslyn server per buffer -> duplicate
    -- diagnostics/completion and duplicate CodeLens (the stacked "N references"
    -- + "Run/Debug tests" virtual lines). Disable it so easy-dotnet is used
    -- only as the test runner / build helper below.
    opts = { lsp = { enabled = false } },
    keys = {
      { "<leader>tt", "<cmd>Dotnet testrunner<cr>", desc = ".NET test runner" },
      { "<leader>tr", "<cmd>Dotnet run<cr>", desc = ".NET run" },
      { "<leader>tb", "<cmd>Dotnet build<cr>", desc = ".NET build" },
    },
  },
}
