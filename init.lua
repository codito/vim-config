-- NVIM config file
-- Created: Aug 2005. Ported to neovim on 11/12/2021. Ported to init.lua on 14/09/2024.
-- Last Modified: 14/09/2024, 08:52:12 +0530

-- Platform {{{1
--
-- Local settings file, default to linux
local pluginDir = "~/.vim/bundle"
local sessionDir = vim.fn.expand("$HOME") .. "/.vim/sessions"
local snippetsDir = vim.fn.expand("$HOME") .. "/.vim/snips"

-- Know the platform we're running on
function getPlatform()
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return "win"
  end

  return "nix"
end

-- Get ready for life w/o walls
if getPlatform() == "win" then
  pluginDir = vim.fn.expand("~/vimfiles/bundle")
  sessionDir = vim.fn.expand("$HOME/vimfiles/sessions")
  snippetsDir = vim.fn.expand("$HOME/vimfiles/snips")
  vim.g.skip_loading_mswin = 1

  vim.opt.selection = "exclusive"
  vim.opt.selectmode = "mouse,key"
  vim.opt.mousemodel = "popup"
  vim.opt.keymodel = "startsel,stopsel"
end

-- Pure vim {{{1
--
-- Autocomplete
vim.opt.complete:append("k") -- scan the files given with the 'dictionary' option
vim.opt.wildmenu = true -- command-line completion operates in an enhanced mode
vim.opt.wildignore = "*.bak,*.o,*.e,*~,*.pyc" -- ignore these

-- Buffers
vim.opt.autoread = true -- read open files again when changed outside Vim
vim.opt.autowrite = true -- write a modified buffer on each :next , ...
vim.opt.backspace = "indent,eol,start" -- define backspace behavior
vim.opt.bufhidden = "delete" -- delete hidden buffers, changes will be lost!

-- Directories and files
vim.opt.autochdir = false -- don't switch directory to current file
vim.opt.isfname:append("32") -- consider space as a valid filename char, useful for `gf`

-- Diff
vim.opt.diffopt:append("vertical") -- vertical diffs are natural

-- Platform-specific settings
if getPlatform() == "win" then
  vim.opt.backupdir = "~/vimfiles/tmp"
  vim.opt.directory = "~/vimfiles/tmp"
else
  vim.opt.backupdir = "~/.vim/tmp" -- isolate the swap files to some corner
  vim.opt.directory = "~/.vim/tmp" -- directories for swap files
end

-- Diff
vim.opt.diffopt:append("vertical") -- vertical diffs are natural

-- Editor appearance
if vim.fn.exists("+termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.opt.background = "light"
vim.opt.foldmethod = "syntax" -- default fold by syntax
vim.opt.number = true -- enable line number
vim.opt.cpo = "" -- don't be vi compatible
vim.opt.ruler = true -- show the line,col info at bottom
vim.opt.showcmd = true -- show partial cmd in the last line
vim.opt.showmatch = true -- jump to the other end of a curly brace
vim.opt.showmode = true -- show the mode INSERT/REPLACE/...
vim.cmd("syntax enable") -- enable syntax highlighting
vim.opt.textwidth = 80 -- break a line after 80 characters
vim.opt.ea = false -- for :split don't split space equally
vim.opt.visualbell = true -- oh no beeps please!
vim.opt.cursorline = true -- highlight the line our cursor is in
vim.opt.signcolumn = "number" -- use the line number for signs (test, debug etc.)

-- Ruler and status
vim.opt.rulerformat = ""
vim.opt.rulerformat:append("%25(%)") -- 25 chars wide
vim.opt.rulerformat:append("%=")
-- vim.opt.rulerformat:append("%(%Ll,%{\ wordcount().words}\w%)")  -- Lines and words
-- vim.opt.rulerformat:append("%=")
-- vim.opt.rulerformat:append("%(\ %l,%c%V%)")  -- Cursor line and char
vim.opt.rulerformat:append("%=")
vim.opt.rulerformat:append("%P") -- Pager

-- Key mappings in general
vim.api.nvim_set_keymap("n", "<S-Tab>", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-F4>", ":bdelete<CR>", { silent = true })

-- Omnicomplete
-- vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertLeave" }, {
--   pattern = "*",
--   callback = function()
--     if vim.fn.pumvisible() == 0 then
--       vim.fn.pclose()
--     end
--   end,
-- })
vim.opt.completeopt = "menuone,menu,longest,noinsert,noselect,preview"
vim.opt.shortmess:append("c") -- do not pass short messages to completion menu

-- Search
vim.opt.incsearch = true -- use incremental search
vim.opt.whichwrap = "<,>,h,l,[,]]" -- set wrapping at the end of line
vim.opt.wrapscan = true -- wrap the search

-- Tabs and Indentation
vim.opt.cindent = true -- support c indenting style
vim.opt.expandtab = true -- use spaces for indentation
vim.opt.softtabstop = 4 -- replace tabs with 4 spaces
vim.opt.shiftwidth = 4 -- for inserting spaces with S-<< and S->>
vim.opt.tabstop = 8 -- defacto tab standard

-- Tags
vim.opt.sft = true -- show full tags while autocompleting
vim.opt.tags = "tags,./tags,../,../.."

-- Misc
vim.cmd("filetype plugin on") -- enable plugin support

-- GUI
if
  vim.fn.has("gui") == 1
  or vim.fn.exists("nvy") == 1
  or vim.fn.exists("GuiLoaded") == 1
  or vim.fn.exists("g:neovide") == 1
then
  vim.opt.guifont = "Iosevka NFM:h14"

  -- enable Shift+Insert
  vim.api.nvim_set_keymap("i", "<S-Insert>", "<C-R>+", { silent = true })
end

-- Language and file types
vim.cmd("filetype plugin indent on") -- Filetype plugin

-- Plugins {{{1
-- This needs to be set before plugins so that plugin init codes can read the mapleader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
require("plugin")

-- Gruvbox color
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_better_performance = 1
vim.cmd("colorscheme gruvbox-material")

-- Load lua based plugin configuration {{{1
-- Setup local luarock packages
-- Required for image.nvim for now
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?.lua;"

require("impatient")
require("config")

-- Local machine dependent mods {{{1
--
local localFile = "~/.local.vim"
if getPlatform() == "win" then
  localFile = vim.fn.expand("~/local.vim")
end

if vim.fn.filereadable(vim.fn.expand(localFile)) then
  vim.cmd("source " .. localFile)
end

-- vim: foldmethod=marker fileformat=unix foldmarker={{{,}}}
-- EOF
