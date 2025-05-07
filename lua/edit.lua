-- Editor options
-- Created: 14/09/2024, 07:12:27 +0530. Migrated from init.vim.
-- Last updated: 07/05/2025, 08:06:50 +0530
local Terminal = require("toggleterm.terminal").Terminal

-- Language and filetypes {{{1
-- C/C++
if vim.fn.has("win32") or vim.fn.has("win64") then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
      vim.opt_local.errorformat = "%f(%l) : error C%n: %m"
    end,
  })
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.colorcolumn = 80
    vim.opt_local.textwidth = 80
  end,
})

-- C#
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldmarker = "{,}"
    vim.opt_local.foldtext = function()
      return vim.fn.substitute(
        vim.fn.getline(vim.fn.foldstart() + 1),
        "{.*",
        "{...}",
        ""
      )
    end
    vim.opt_local.foldlevel = 3
  end,
})

-- CSS
vim.api.nvim_create_autocmd("FileType", {
  pattern = "css",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 4
  end,
})

-- HTML
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 4
  end,
})

-- Javascript
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 4
  end,
})

-- Json
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 4
  end,
})

-- Mail
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "/tmp/mutt-*",
  callback = function()
    vim.opt_local.filetype = "mail"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mail",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.tw = 66
    vim.opt_local.autoindent = true
    vim.opt_local.expandtab = true
    vim.opt_local.formatoptions = "tcqn"
    vim.opt_local.list = true
    vim.opt_local.listchars = "tab:»·,trail:·"
    vim.opt_local.comments = "nb:>"

    vim.api.nvim_buf_set_keymap(0, "v", "D", "dO[...]^[", { noremap = true })
    vim.api.nvim_command("silent normal /--\\s*$^MO^[gg/^$^Mj")
  end,
})

-- Powershell
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ps1",
  callback = function()
    vim.opt_local.filetype = "ps1"
  end,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.autoindent = true
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tw = 80
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.list = false
    vim.opt_local.wrapmargin = 0
    vim.opt_local.autoindent = true
    vim.opt_local.formatoptions = "tcroqn"
    vim.opt_local.comments = "n:>"
    vim.opt_local.conceallevel = 0
    vim.opt_local.foldenable = false
  end,
})

-- Text
-- vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
--     pattern = "*.txt",
--     callback = function()
--         vim.opt_local.filetype = "txt"
--     end
-- })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "txt",
  callback = function()
    vim.opt_local.tw = 80
    vim.opt_local.autoindent = true
    vim.opt_local.expandtab = true
    vim.opt_local.formatoptions = "tawqn"
  end,
})

-- Typescript
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.autoindent = true
  end,
})

-- XML
vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.autoindent = true
  end,
})

-- Navigation {{{1
-- Enable camelCase text navigation {{{2
-- Key Mappings for camelCase
vim.g.camelchar = "A-Z0-9.,;:{([`'\"" -- catch-all. class member, separator, end of statement, brackets and quotes

-- Timestamps {{{1
-- Expand current date time stamp {{{2
-- Use for file timestamp updates or journal.
vim.api.nvim_set_keymap(
  "i",
  "dts",
  vim.fn.strftime(vim.g.timestamp_rep),
  { expr = true }
)
vim.api.nvim_set_keymap(
  "i",
  "<leader>ts",
  vim.fn.strftime(vim.g.timestamp_rep),
  { expr = true }
)
-- Timestamp for blog posts.
vim.api.nvim_set_keymap(
  "i",
  "<leader>tb",
  vim.fn.strftime("%Y-%m-%d %H:%M"),
  { expr = true }
)
vim.g.timestamp_regexp =
  [[\v\C%(<[lL]ast %([cC]hanged?|[Mm]odified|[Uu]pdated):\s+)@<=.*$|TIMESTAMP]]
vim.g.timestamp_modelines = 50
vim.g.timestamp_rep = "%d/%m/%Y, %T %z"

-- Glow {{{1
vim.api.nvim_set_keymap(
  "n",
  "<leader>p",
  "<cmd>TermExec cmd='glow % | less'<CR>",
  { noremap = true, silent = true }
)

-- Lazygit {{{1
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  hidden = true,
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>gg",
  "<cmd>lua _lazygit_toggle()<CR>",
  { noremap = true, silent = true }
)
-- Lexical {{{1
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.call("lexical#init", {})
  end,
})

-- Markdown {{{1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1

-- Mini.diff {{{1
require("mini.diff").setup({
  view = {
    style = "number",
  },
})

-- Netrw plugin {{{1
vim.g.netrw_browse_split = 3 -- all edits in new tab
if vim.fn.has("unix") == 1 then
  vim.g.netrw_browsex_viewer = "xdg-open"
end

-- nvim-tree {{{1
vim.api.nvim_set_keymap("n", "<F7>", ":NvimTreeToggle<cr>", { silent = true })

-- Pencil {{{1
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.call("pencil#init", { wrap = "hard" })
  end,
})
vim.g["pencil#textwidth"] = vim.opt.textwidth:get()
vim.g["pencil#conceallevel"] = 0
vim.g["pencil#concealcursor"] = "c"
vim.g["pencil#autoformat"] = 0 -- Disable autoformat to allow markdown bullets to work without auto joins with previous line

-- Table mode {{{1
-- Settings for vim-table-mode
vim.g.table_mode_corner = "|" -- markdown compatible tables by default
vim.g.table_mode_tableize_map = "<leader>tb"

-- Television {{{1
local tv = Terminal:new({
  cmd = "tv",
  dir = "git_dir",
  direction = "float",
  hidden = true,
})

function _tv_toggle()
  tv:toggle()
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>tv",
  "<cmd>lua _tv_toggle()<CR>",
  { noremap = true, silent = true }
)

-- vim: foldmethod=marker foldmarker={{{,}}}
-- EOF
