-- Setup for lazy.nvim and plugin sources
-- Created: 14/09/2024, 07:09:32 +0530
-- Last updated: 14/09/2024, 08:16:27 +0530

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
    -- 3rd party plugins
    {
      "3rd/image.nvim",
      cond = function()
        return getPlatform() == "nix"
      end,
      ft = { "markdown" },
    },
    { "andythigpen/nvim-coverage" },
    { "antoinemadec/FixCursorHold.nvim" },
    { "brenoprata10/nvim-highlight-colors" },
    { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
    { "editorconfig/editorconfig-vim" },
    { "ellisonleao/glow.nvim" },
    { "folke/trouble.nvim" },
    { "folke/twilight.nvim" },
    { "folke/zen-mode.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-emoji" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "issafalcon/neotest-dotnet" },
    { "kdheepak/lazygit.nvim" },
    { "konfekt/fastfold" },
    { "kyazdani42/nvim-tree.lua" },
    { "kyazdani42/nvim-web-devicons" },
    { "l3mon4d3/luasnip" },
    { "lewis6991/impatient.nvim" },
    { "mattn/calendar-vim" },
    { "milanglacier/minuet-ai.nvim" },
    { "mfussenegger/nvim-dap" },
    { "mfussenegger/nvim-dap-python" },
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
    { "rcarriga/nvim-dap-ui" },
    { "romgrk/nvim-treesitter-context" },
    { "ron89/thesaurus_query.vim" },
    { "rouge8/neotest-rust", ft = "rust" },
    { "saadparwaiz1/cmp_luasnip" },
    { "stevearc/aerial.nvim" },
    { "stevearc/conform.nvim" },
    { "stevearc/dressing.nvim" },
    { "tweekmonster/startuptime.vim" },
    { "uga-rosa/cmp-dictionary" },
    { "vim-scripts/timestamp.vim" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Colors
    { "f4z3r/gruvbox-material.nvim" },
    { "kepano/flexoki-neovim" },
  },
})
