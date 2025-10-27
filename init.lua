-- NVIM config file
-- Created: Aug 2005. Ported to neovim on 11/12/2021. Ported to init.lua on 14/09/2024.
-- Last Modified: 08/10/2025, 19:25:04 +0530

local utils = require("util")

-- Platform {{{1
--
-- Local settings file, default to linux
local pluginDir = "~/.vim/bundle"
local sessionDir = vim.fn.expand("$HOME") .. "/.vim/sessions"
local snippetsDir = vim.fn.expand("$HOME") .. "/.vim/snips"

-- Get ready for life w/o walls
if utils.getPlatform() == "win" then
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

-- Platform-specific settings
if utils.getPlatform() == "win" then
  vim.opt.backupdir = vim.fn.expand("~/vimfiles/tmp")
else
  vim.opt.backupdir = vim.fn.expand("~/.vim/tmp") -- isolate the swap files to some corner
end

-- Diff
vim.opt.diffopt:append("vertical") -- vertical diffs are natural

-- Key mappings in general
vim.api.nvim_set_keymap("n", "<S-Tab>", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-F4>", ":bdelete<CR>", { silent = true })

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

-- Colorscheme
-- vim.g.gruvbox_material_background = "hard"
-- vim.g.gruvbox_material_diagnostic_text_highlight = 1
-- vim.g.gruvbox_material_better_performance = 1
-- vim.cmd("colorscheme gruvbox-material")
vim.cmd("colorscheme catppuccin-frappe")

-- Load lua based plugin configuration {{{1
-- Setup local luarock packages
-- Required for image.nvim for now
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luarocks/share/lua/5.1/?/init.lua;"
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luarocks/share/lua/5.1/?.lua;"

require("impatient")
require("config")

-- Local machine dependent mods {{{1
--
local localFile = vim.fn.expand("~/.local.vim")
if utils.getPlatform() == "win" then
  localFile = vim.fn.expand("~/local.vim")
end

if vim.fn.filereadable(localFile) then
  vim.cmd("source " .. localFile)
end

-- vim: foldmethod=marker fileformat=unix foldmarker={{{,}}}
-- EOF
