-- Setup for lazy.nvim and plugin sources
-- Created: 14/09/2024, 07:09:32 +0530
-- Last updated: 13/06/2025, 15:58:06 +0530

local utils = require("util")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "3rd/image.nvim",
      cond = function()
        return utils.getPlatform() == "nix"
      end,
      ft = { "markdown" },
    },
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    { "andythigpen/nvim-coverage" },
    { "antoinemadec/FixCursorHold.nvim" },
    { "brenoprata10/nvim-highlight-colors" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
    { "echasnovski/mini.diff", version = false },
    { "folke/twilight.nvim" },
    { "folke/zen-mode.nvim" },
    { "hrsh7th/cmp-emoji" },
    { "issafalcon/neotest-dotnet" },
    { "konfekt/fastfold" },
    { "kdheepak/cmp-latex-symbols" },
    { "kyazdani42/nvim-tree.lua" },
    { "kyazdani42/nvim-web-devicons" },
    { "l3mon4d3/luasnip" },
    { "lewis6991/impatient.nvim" },
    { "milanglacier/minuet-ai.nvim" },
    {
      "mfussenegger/nvim-dap",
      lazy = true,
      dependencies = { { "igorlfs/nvim-dap-view", opts = {} } },
    },
    { "mfussenegger/nvim-dap-python" },
    { "neovim/nvim-lspconfig" },
    { "numtostr/comment.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-neotest/neotest" },
    { "nvim-neotest/neotest-python", ft = { "python" } },
    { "nvim-neotest/nvim-nio" },
    { "nvim-telescope/telescope.nvim", version = "0.1.x" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "olimorris/codecompanion.nvim" },
    { "preservim/vim-pencil", ft = "markdown" },
    { "preservim/vim-lexical", ft = "markdown" },
    { "rafamadriz/friendly-snippets" },
    { "romgrk/nvim-treesitter-context" },
    { "ron89/thesaurus_query.vim" },
    { "rouge8/neotest-rust", ft = "rust" },
    { "sadotsoy/vim-xit", ft = "xit" },
    {
      "saghen/blink.cmp",
      version = "1.*",
      dependencies = {
        { "saghen/blink.compat" },
      },
    },
    { "stevearc/aerial.nvim" },
    { "stevearc/conform.nvim" },
    { "stevearc/dressing.nvim" },
    { "vim-scripts/timestamp.vim" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "zbirenbaum/copilot.lua",
      cond = function()
        return utils.getPlatform() == "win"
      end,
    },

    -- Colors
    { "f4z3r/gruvbox-material.nvim" },
    { "kepano/flexoki-neovim" },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
