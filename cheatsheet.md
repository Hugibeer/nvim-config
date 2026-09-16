# Neovim Cheat Sheet

Open this from inside Neovim with `<leader>hc` or `:Cheatsheet`.
`<leader>` is **Space**, `<localleader>` is **\\** (backslash).

> Live alternative: press `<leader>?` for a which-key popup of the keymaps
> active in the **current buffer** (it reads the same `desc` labels below).
> And `:help <thing>` / `K` (on a symbol) are the built-in lookups.

---

## My custom keymaps

### General

| Key          | Action                                              |
| ------------ | --------------------------------------------------- |
| `<leader>uw` | Toggle word wrap                                    |
| `<leader>?`  | which-key popup of this buffer's keymaps            |
| `<leader>hc` | Open this cheat sheet                               |

### Telescope (find)

| Key          | Action                       |
| ------------ | ---------------------------- |
| `<leader>ff` | Find files                   |
| `<leader>fg` | Live grep across the project |
| `<leader>fb` | Browse open buffers          |
| `<leader>fr` | Recent files                 |
| `<leader>fh` | Help tags                    |

Inside any picker: `<C-v>` opens the selection in a vertical split,
`<C-x>` in a horizontal one.

### Merge conflicts (git mergetool / diff mode)

| Key / Command | Action                                             |
| ------------- | -------------------------------------------------- |
| `<F8>`        | Next conflict/diff hunk (`]c`, AltGr-free)         |
| `<F7>`        | Previous conflict/diff hunk (`[c`, AltGr-free)     |
| `<leader>ml`  | Take my branch's version of the hunk (LOCAL)       |
| `<leader>mr`  | Take the incoming version (REMOTE, e.g. master)    |
| `<leader>mb`  | Take the common ancestor's version (BASE)          |
| `:%diffget LOCAL` | Take one side for the WHOLE file (also REMOTE) |
| `:wqa`        | Save resolution, continue to next conflicted file  |

Run from the bottom (MERGED) window with the cursor anywhere inside the hunk —
no selection needed. Resolved = no `<<<<<<<` markers left in MERGED (`/<<<` to
check). Avoid `:diffget LO`: it matches buffer *names* incl. the file path, so
e.g. deploy.yml matches "LO" in every window ("More than one match").

### LSP (active in C# and Markdown buffers)

| Key          | Action                                              |
| ------------ | --------------------------------------------------- |
| `gd`         | Go to definition                                    |
| `gD`         | Go to declaration                                   |
| `gi`         | Go to implementation                                |
| `gr`         | References                                          |
| `K`          | Hover docs (press again to jump into the float)     |
| `<leader>rn` | Rename symbol                                       |
| `<leader>ca` | Code action                                         |
| `<leader>cf` | Format buffer (normal + visual)                     |

Completion autotriggers as you type. `<C-n>`/`<C-p>` cycle items, `<C-y>`
accepts, `<C-e>` cancels, `<C-x><C-o>` triggers it manually.

### .NET (easy-dotnet, C# buffers)

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>tt` | .NET test runner  |
| `<leader>tr` | .NET run          |
| `<leader>tb` | .NET build        |

### Debug (nvim-dap)

| Key          | Action                        |
| ------------ | ----------------------------- |
| `<F5>`       | Start / Continue              |
| `<F9>`       | Toggle breakpoint             |
| `<F10>`      | Step over                     |
| `<F11>`      | Step into                     |
| `<F12>`      | Step out                      |
| `<leader>dB` | Conditional breakpoint        |
| `<leader>dr` | Toggle REPL                   |
| `<leader>du` | Toggle DAP UI                 |
| `<leader>dt` | Terminate                     |

### Markdown

| Key / Command            | Action                              |
| ------------------------ | ----------------------------------- |
| `<leader>mp`             | Browser live preview toggle         |
| `:RenderMarkdown toggle` | Toggle in-buffer rendering          |

### Commands

| Command       | Action                          |
| ------------- | ------------------------------- |
| `:Cheatsheet` | Open this file                  |
| `:Cobalt2`    | Switch to the Cobalt2 theme     |
| `:ConformInfo`| Show formatter status           |
| `:Dotnet ...` | easy-dotnet commands            |
| `:Lazy`       | Plugin manager UI               |
| `:Mason`      | LSP/tool installer UI           |
| `:checkhealth`| Diagnose config problems        |

---

## Core Neovim reference

### Modes

| Key       | Mode                                       |
| --------- | ------------------------------------------ |
| `i` / `a` | Insert before / after cursor               |
| `I` / `A` | Insert at line start / end                 |
| `o` / `O` | Open new line below / above                |
| `v` / `V` | Visual (char) / Visual line                |
| `<C-v>`   | Visual block                               |
| `R`       | Replace mode                               |
| `<Esc>`   | Back to Normal mode (`<C-[>` also works)   |
| `:`       | Command-line                               |

### Quitting & saving

| Command       | Action                                  |
| ------------- | --------------------------------------- |
| `:w`          | Save                                    |
| `:q`          | Quit (refuses if unsaved changes)       |
| `:q!`         | Quit, discard changes                   |
| `:wq` / `:x`  | Save and quit                           |
| `:qa` / `:qa!`| Quit all windows (force with `!`)       |
| `ZZ` / `ZQ`   | Save+quit / quit-without-save (Normal)  |

### Motions

| Key          | Move                                       |
| ------------ | ------------------------------------------ |
| `h j k l`    | Left, down, up, right                      |
| `w` / `b`    | Next / previous word start                 |
| `e` / `ge`   | Next / previous word end                   |
| `0` / `^`    | Line start / first non-blank               |
| `$`          | Line end                                   |
| `gg` / `G`   | First / last line                          |
| `{n}G`       | Go to line *n* (or `:{n}`)                 |
| `{` / `}`    | Previous / next paragraph                  |
| `%`          | Matching bracket                           |
| `f{c}`/`t{c}`| Jump to / before next char `c` (`;`/`,` repeat) |
| `<C-d>`/`<C-u>`| Half page down / up                      |
| `<C-f>`/`<C-b>`| Full page forward / back                 |
| `zz`/`zt`/`zb`| Center / top / bottom current line       |

### Editing

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `x` / `X`    | Delete char under / before cursor          |
| `dd` / `yy`  | Delete (cut) / yank (copy) line            |
| `d{motion}`  | Delete over motion (e.g. `dw`, `d$`)       |
| `c{motion}`  | Change over motion (delete + insert)       |
| `p` / `P`    | Paste after / before                       |
| `r{c}` / `R` | Replace one char / replace mode            |
| `u` / `<C-r>`| Undo / redo                                |
| `.`          | Repeat last change                         |
| `>>` / `<<`  | Indent / dedent line                       |
| `J`          | Join line below onto current               |
| `~`          | Toggle case of char                        |
| `gu`/`gU`    | Lowercase / uppercase over motion          |

### Text objects (use with `d`, `c`, `y`, `v`)

| Object       | Selects                                    |
| ------------ | ------------------------------------------ |
| `iw` / `aw`  | Inner / a word                             |
| `i"` / `a"`  | Inside / around quotes (also `'` `` ` ``)  |
| `i(` / `a(`  | Inside / around parens (also `[ { <`)      |
| `it` / `at`  | Inside / around an (X|HT)ML tag            |
| `ip` / `ap`  | Inner / a paragraph                        |

Examples: `ciw` change word, `di(` delete inside parens, `ya"` yank quoted string.

### Selection & clipboard

> **This config sets `clipboard = "unnamedplus"`**, so every yank/delete/paste
> already goes through the **system clipboard**. You can copy in Neovim and
> paste into another app (and vice-versa) without the `"+` prefix.

**Make a selection (Visual mode):**

| Key          | Action                                          |
| ------------ | ----------------------------------------------- |
| `v`          | Char-wise selection (extend with motions)       |
| `V`          | Line-wise selection                             |
| `<C-v>`      | Block/column selection                          |
| `gv`         | Reselect the last selection                     |
| `o`          | Jump to the other end of the selection          |
| `viw`/`vi"`  | Select a text object (word, quotes, `i(`, `it`…)|
| `ggVG`       | Select the whole file                           |
| `<Esc>`      | Leave Visual mode                               |

**Act on a selection** (while it's highlighted):

| Key       | Action                                             |
| --------- | -------------------------------------------------- |
| `y`       | Yank (copy) the selection                          |
| `d` / `x` | Delete (cut) the selection                         |
| `c`       | Change — delete and drop into Insert mode          |
| `p`       | Replace the selection with the clipboard contents  |
| `>` / `<` | Indent / dedent                                    |
| `u` / `U` | Lowercase / uppercase the selection                |

**Copy / cut / paste (Normal mode):**

| Key          | Action                                          |
| ------------ | ----------------------------------------------- |
| `yy` / `dd`  | Copy / cut the current line                      |
| `yiw`/`yi"`  | Copy a word / quoted string                      |
| `p` / `P`    | Paste after / before cursor                      |
| `]p`         | Paste and reindent to current line               |

**Explicit system clipboard** (for the rare case you've changed `clipboard`):
`"+y` copy, `"+p` paste, `"+yy` copy line. `"+` = system clipboard, `"*` = selection.

**Mouse** (this config sets `mouse = "a"`): click-drag selects into Visual mode;
that selection is on the system clipboard, so `Ctrl+V` pastes it elsewhere.
In Insert mode, paste with your terminal's shortcut (often `Cmd+V`). To paste
literally without auto-indent mangling code, that path or `"+p` in Normal
mode is safest.

### Search & replace

| Key / Command         | Action                                    |
| --------------------- | ----------------------------------------- |
| `/text` / `?text`     | Search forward / backward                 |
| `n` / `N`             | Next / previous match                     |
| `*` / `#`             | Search word under cursor fwd / back       |
| `:noh`                | Clear search highlight                    |
| `:%s/old/new/g`       | Replace all in file                       |
| `:%s/old/new/gc`      | Replace all, confirm each                 |
| `:s/old/new/g`        | Replace all on current line               |

### Windows / splits

| Key / Command  | Action                                     |
| -------------- | ------------------------------------------ |
| `:vs {file}` / `:sp {file}` | Open a file in a vertical / horizontal split |
| `<C-w>v`/`<C-w>s`| Split current file vertical / horizontal |
| `<C-w>h/j/k/l` | Move to split left/down/up/right           |
| `<C-w>w`       | Cycle to next split                        |
| `<C-w>p`       | Back to previously focused split           |
| `<C-w>q` / `:q`| Close split (the buffer stays open)        |
| `<C-w>o`       | Close all other splits (`:only`)           |
| `<C-w>=`       | Equalize split sizes                       |
| `<C-w>>` / `<C-w><` | Widen / narrow current split          |

From **nvim-tree** or a **Telescope** picker: `<C-v>` opens the file under the
cursor in a vertical split, `<C-x>` in a horizontal one.

### Buffers / tabs

> A **buffer** is a file loaded in memory; a **window** is a viewport onto one.
> Files opened via nvim-tree/Telescope stay open as buffers even when no window
> shows them — `<leader>fb` gets you back to any of them.

| Key / Command   | Action                                          |
| --------------- | ----------------------------------------------- |
| `<leader>fb`    | Fuzzy-pick from open buffers (Telescope)        |
| `:e {file}`     | Open / edit a file                              |
| `:ls`           | List buffers (`%` current, `#` alternate, `+` unsaved) |
| `<C-^>`         | Toggle to the alternate (previous) buffer       |
| `:bn` / `:bp`   | Next / previous buffer                          |
| `:b {name}`     | Switch to buffer by name (Tab-completes)        |
| `:b {n}`        | Switch to buffer number *n* (from `:ls`)        |
| `:bd` / `:bd!`  | Close buffer (`!` discards unsaved changes)     |
| `:%bd \| e#`    | Close all buffers except the current file       |
| `:tabnew`       | New tab                                         |
| `gt` / `gT`     | Next / previous tab                             |

### Marks, registers, macros, folds

| Key            | Action                                   |
| -------------- | ---------------------------------------- |
| `m{a}` / `` `{a} `` | Set mark a / jump to mark a         |
| `` `` ``       | Jump back to position before last jump   |
| `"{r}y` / `"{r}p` | Yank to / paste from register r       |
| `"+y` / `"+p`  | Yank to / paste from system clipboard    |
| `q{r}` … `q`   | Record macro into register r             |
| `@{r}` / `@@`  | Play macro r / replay last macro         |
| `za` / `zR` / `zM` | Toggle fold / open all / close all   |

---

*Generated for this config. Edit `cheatsheet.md` in the repo to extend it.*
