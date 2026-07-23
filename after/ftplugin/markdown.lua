-- gf on markdown links: strip #anchors, decode %20 → space
vim.opt_local.includeexpr =
  [[substitute(substitute(v:fname, '#.*$', '', ''), '%20', ' ', 'g')]]
