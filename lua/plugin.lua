-- Setup for lazy.nvim and plugin sources
-- Created: 14/09/2024, 07:09:32 +0530
-- Last updated: 01/01/2026, 07:48:14 +0530

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
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    { "andythigpen/nvim-coverage" },
    { "antoinemadec/FixCursorHold.nvim" },
    { "brenoprata10/nvim-highlight-colors" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
    { "echasnovski/mini.diff", version = false },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
    },
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
    { "necrom4/calcium.nvim", cmd = { "Calcium" } },
    { "neovim/nvim-lspconfig" },
    { "numtostr/comment.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-neotest/neotest" },
    { "nvim-neotest/neotest-python", ft = { "python" } },
    { "nvim-neotest/nvim-nio" },
    { "nvim-telescope/telescope.nvim", branch = "master" },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      branch = "main",
      build = ":TSUpdate",
    },
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
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
