-- Editor appearance
-- Created: 23/11/2024, 06:18:18 +0530
-- Last updated: 01/08/2025, 12:08:59 +0530

if vim.fn.exists("+termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.opt.background = "dark"
vim.opt.foldmethod = "syntax" -- default fold by syntax
vim.opt.number = true -- enable line number
vim.opt.cpo = "" -- don't be vi compatible
vim.opt.ruler = true -- show the line,col info at bottom
vim.opt.showcmd = true -- show partial cmd in the last line
vim.opt.showmatch = true -- jump to the other end of a curly brace
vim.opt.showmode = true -- show the mode INSERT/REPLACE/...
vim.cmd("syntax enable") -- enable syntax highlighting
vim.opt.textwidth = 80 -- width used for line breaks, 80 has best readability
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

-- Neovide settings
if vim.fn.has("win32") or vim.fn.has("win64") then
  if vim.g.neovide then
    -- disable animations
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
  end
end

-- Snacks configuration
-- See https://github.com/folke/snacks.nvim/blob/main/README.md
require("snacks").setup({
  -- dim = { enabled = true },
  image = { enabled = true },
  -- zen = { enabled = true },
})

-- vim.keymap.set("n", "<leader>z", function()
--   require("snacks").zen()
-- end)
