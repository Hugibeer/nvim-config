-- C# / .NET via the Roslyn language server (roslyn.nvim).
-- Far faster and more capable than OmniSharp; provides completion, navigation,
-- diagnostics, code actions, and semantic-token highlighting. The server binary
-- ("roslyn") is installed by mason-tool-installer in lsp.lua; roslyn.nvim
-- auto-detects the mason install and manages the LSP client itself.
--
-- No nvim-treesitter for C# (it would reintroduce the markdown parser conflict
-- on nvim 0.12). Highlighting comes from Roslyn semantic tokens + Vim's bundled
-- cs syntax. Shared LSP keymaps come from the global LspAttach autocmd in init.lua.

-- The settings below only make the server capable of producing inlay hints;
-- Neovim still needs an explicit per-buffer enable to render them (unlike
-- diagnostics, which show automatically). Scoped to "roslyn" specifically so
-- this doesn't affect other languages.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "roslyn" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    -- Config must be applied via `init`, not `opts`: roslyn.nvim's
    -- plugin/roslyn.lua calls vim.lsp.enable("roslyn") (which resolves the
    -- root and starts the client for the buffer that triggered this ft-load)
    -- the moment the plugin loads. Lazy.nvim sources plugin/*.lua before
    -- calling the opts-driven config/setup, so an `opts` table here would
    -- apply one buffer too late — after the first (and often wrong) root
    -- has already been picked. `init` runs before the plugin loads.
    init = function()
      require("roslyn").setup({
        -- Once a target .sln is resolved for a root_dir, keep using it
        -- instead of re-resolving (and re-prompting on any new ambiguity)
        -- on every buffer.
        lock_target = true,
        -- GSCLite ships both the full workspace solution (GSCLite.sln at the
        -- repo root, ~23 projects) and a per-project one scoped to just the
        -- web app (GSCLite/GSCLite.sln) for tooling other than the editor.
        -- Without this, roslyn.nvim treats both as valid targets for any
        -- buffer under GSCLite/ and prompts to pick one — and picking the
        -- per-project solution loads GSCLite.csproj without its
        -- ProjectReferences (Database.Client, Dto, Service.Helper, ...),
        -- breaking navigation across the rest of the solution.
        ignore_target = function(target)
          return target:match("/GSCLite/GSCLite%.sln$") ~= nil
        end,
      })

      -- roslyn.nvim's own setup() above only takes its plugin-behavior
      -- options (lock_target, choose_target, ...) — it does not forward
      -- arbitrary LSP `settings`/`capabilities`, so those go straight
      -- through vim.lsp.config (merged onto roslyn.nvim's bundled
      -- lsp/roslyn.lua defaults). Must also happen here in `init`, for the
      -- same reason as above: roslyn.nvim's plugin/roslyn.lua calls
      -- vim.lsp.enable("roslyn") the moment it loads, so anything set later
      -- (e.g. via `opts`) would miss the first buffer.
      --
      -- This is nvim-lspconfig's bundled roslyn_ls default `settings`
      -- block, ported over — roslyn.nvim ships none of this itself, so
      -- without it you get the bare server defaults: no inlay hints, no
      -- full-solution background diagnostics, no references CodeLens.
      vim.lsp.config("roslyn", {
        capabilities = {
          -- HACK (same one nvim-lspconfig's roslyn_ls carries): the server
          -- doesn't push any diagnostics at all unless the client claims
          -- dynamic registration support for pull diagnostics.
          textDocument = {
            diagnostic = {
              dynamicRegistration = true,
            },
          },
        },
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_provide_regex_completions = true,
          },
          -- Enables the server-side capability only; Neovim still needs an
          -- explicit vim.lsp.codelens.refresh() to render it, which we're
          -- deliberately not wiring up — this was the exact "stacked
          -- reference count" virtual-text clutter the dotnet.lua comment
          -- flagged as an annoyance back when two roslyn servers were
          -- attached. Harmless to leave enabled here in case that's wanted
          -- later.
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
    end,
  },
}
