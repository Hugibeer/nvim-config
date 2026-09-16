-- Bare Neovim + a focused Markdown stack.
-- Plugin manager: lazy.nvim (bootstrapped below). Added 2026-06-22.

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Sensible + markdown-friendly options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- macOS: nvim auto-detects pbcopy/pbpaste
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.conceallevel = 2 -- let render-markdown hide raw markup
opt.wrap = false -- wrap long prose
opt.linebreak = true -- wrap at word boundaries, not mid-word
opt.breakindent = true
-- noselect: the completion menu shows without auto-inserting/pre-selecting
-- the first match, so typing keeps filtering instead of fighting a prefill.
opt.completeopt = "menu,menuone,noselect"

-- Per-filetype markdown tweaks: native treesitter highlight (bundled 0.12
-- parser), spell check + 2-space indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    pcall(vim.treesitter.start)
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Keymaps
vim.keymap.set("n", "<leader>uw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = "Toggle word wrap" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Diff/merge navigation: ]c / [c need AltGr on the Croatian layout, so mirror
-- them on function keys (used mainly inside `git mergetool`).
vim.keymap.set("n", "<F8>", "]c", { desc = "Next diff/conflict" })
vim.keymap.set("n", "<F7>", "[c", { desc = "Previous diff/conflict" })

-- Merge resolution: take the hunk under the cursor from LOCAL/BASE/REMOTE into
-- MERGED. `:diffget LO` matches against full buffer names (path included), so a
-- file like deploy.yml matches "LO" in every window; resolving by buffer number
-- avoids that entirely.
local function diffget_from(which)
  return function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      -- git mergetool names the temp files <name>_LOCAL_<pid>.<ext> (underscores);
      -- also accept dots for other diff tooling.
      if vim.api.nvim_buf_get_name(buf):upper():find("[._]" .. which .. "[._]") then
        vim.cmd(("diffget %d"):format(buf))
        return
      end
    end
    vim.notify("No " .. which .. " buffer in this tab (not in a mergetool session?)", vim.log.levels.WARN)
  end
end
vim.keymap.set("n", "<leader>ml", diffget_from("LOCAL"), { desc = "Merge: take LOCAL (my branch)" })
vim.keymap.set("n", "<leader>mr", diffget_from("REMOTE"), { desc = "Merge: take REMOTE (incoming)" })
vim.keymap.set("n", "<leader>mb", diffget_from("BASE"), { desc = "Merge: take BASE (ancestor)" })

-- Cheat sheet: open cheatsheet.md (in this config dir) in a vertical split.
local function open_cheatsheet()
  local path = vim.fs.joinpath(vim.fn.stdpath("config"), "cheatsheet.md")
  vim.cmd("split " .. vim.fn.fnameescape(path))
end
vim.api.nvim_create_user_command("Cheatsheet", open_cheatsheet, { desc = "Open the Neovim cheat sheet" })
vim.keymap.set("n", "<leader>hc", open_cheatsheet, { desc = "Cheat sheet" })

-- Shared LSP keymaps + native autocompletion, for any attached server
-- (marksman for markdown, roslyn for C#, ...).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local map = function(k, fn, desc)
      vim.keymap.set("n", k, fn, { buffer = buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("K", vim.lsp.buf.hover, "Hover")
    map("gr", vim.lsp.buf.references, "References")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    -- visual-mode variant: passes the selection range so the LSP can offer
    -- selection-based refactors (extract method/variable, etc.), like VS's
    -- Quick Actions lightbulb.
    vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action (selection)" })
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
