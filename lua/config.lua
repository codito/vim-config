-- NVIM lua config
-- Created: 11/12/2021, 11:44:11 +0530
-- Last modified: 20/09/2023, 22:36:46 +0530

-- Aerial {{{1
-- Symbols outliner for neovim
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '<leader>[', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '<leader>]', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>tt', '<cmd>AerialToggle! right<CR>')

-- Codeium {{{1
vim.g.codeium_filetypes = {
    markdown = false
}
vim.g.codeium_disable_bindings = 1
vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true })
vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
-- vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })


-- Comment {{{1
require('Comment').setup()

-- Conform {{{1
require("conform").setup({
    formatters_by_ft = {
        css = { "stylelint" },
        -- lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        astro = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        markdown = { "prettier" },
    },
    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_fallback = true,
      timeout_ms = 500,
    },
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})

-- Coverage {{{1
require("coverage").setup({
    auto_reload = true
})


-- Hologram {{{1
-- https://github.com/edluffy/hologram.nvim
if os.getenv("KITTY_WINDOW_ID") ~= nil or os.getenv("TERM_PROGRAM") == "WezTerm" and vim.g.vscode == nil then
    require('hologram').setup{
        auto_display = true -- WIP automatic markdown image display, may be prone to breaking
    }
end

-- Lsp {{{1
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Set client settings
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
end

local cmp = require "cmp"
local luasnip = require "luasnip"
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    --{ name = 'snippy' }, -- For snippy users.
    { name = 'buffer' },
    { name = 'emoji' },
    { name = 'path' },
  }),
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure the installed lsp servers.
-- lsp_installer setup must be called before lspconfig.
require("mason").setup()
local lsp_installer = require("mason-lspconfig")
lsp_installer.setup()

local lspconfig = require("lspconfig")
require('mason-lspconfig').setup({
    ensure_installed = {
        "astro",
        "csharp_ls",
        "cssls",
        "html",
        "jsonls",
        "ltex",
        "marksman",
        "pyright",
        "ruff_lsp",
        "tsserver",
        "vale_ls",
    },
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities
            })
        end,
    }
})

-- Nvim devicons {{{1
require('nvim-web-devicons').setup({
  default = true
})

-- Nvim tree {{{1
require('nvim-tree').setup({
  update_cwd = false
})

-- Tree sitter {{{1
-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = { 'markdown' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },

  -- Tree sitter context objects {{{2
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },

    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

-- Thesaurus {{{1
vim.cmd [[
func Thesaur(findstart, base)
  if a:findstart
    return searchpos('\<', 'bnW', line('.'))[1] - 1
  endif
  let res = []
  let h = ''
  for l in systemlist('aiksaurus ' .. shellescape(a:base))
    if l[:3] == '=== '
      let h = '(' .. substitute(l[4:], ' =*$', ')', '')
    elseif l ==# 'Alphabetically similar known words are: '
      let h = "\U0001f52e"
    elseif l[0] =~ '\a' || (h ==# "\U0001f52e" && l[0] ==# "\t")
      call extend(res, map(split(substitute(l, '^\t', '', ''), ', '), {_, val -> {'word': val, 'menu': h}}))
    endif
  endfor
  return res
endfunc
]]
vim.opt.thesaurusfunc = "Thesaur"

function ShowSynonymsForWordUnderCursor()
  local word = vim.fn.expand("<cword>")
  vim.cmd("Thesaurus " .. word)
end
vim.keymap.set('n', '<leader>ct', ShowSynonymsForWordUnderCursor, { noremap = true })

-- Trouble {{{1
-- https://github.com/folke/trouble.nvim
require("trouble").setup {
}

-- vim: foldmethod=marker
-- EOF
