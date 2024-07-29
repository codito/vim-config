-- NVIM lua config
-- Created: 11/12/2021, 11:44:11 +0530
-- Last modified: 29/07/2024, 22:53:57 +0530

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

-- Comment {{{1
require('Comment').setup()

-- Conform {{{1
require("conform").setup({
    formatters_by_ft = {
        css = { "stylelint" },
        -- lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "ruff_format" },
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


-- Gen.nvim {{{1
-- For reference, see https://github.com/JoseConseco/nvim_config/blob/master/lua/nv_gen-nvim/init.lua
local gemma_stop = {"<end_of_turn>"}
local gemma_wrap = function(s)
    return "<bos><start_of_turn>user\n" .. s .. "<end_of_turn>\n<start_of_turn>model\n"
end
local codegeex_stop = {"<|user|>", "<|im_end|>"}
local codegeex_sys_prompt = "You are an intelligent programming assistant named CodeGeeX. You will answer any questions users have about programming, coding, and computers, and provide code that is formatted correctly."
local codegeex_wrap = function(s)
    return "<|system|>\n" .. codegeex_sys_prompt .. "\n<|user|>\n" .. s .. "\n<|assistant|>\n"
end

local model_wrap = gemma_wrap
local stop_words = gemma_stop

-- Update local prompts by wrapping them with the selected model
local prompts = require("gen").prompts
for prompt_key, prompt_val in pairs(prompts) do
    prompt_val.prompt = model_wrap(prompt_val.prompt)
end

require('gen').setup({
  display_mode = "split", -- The display mode. Can be "float" or "split".
  show_prompt = false, -- Shows the Prompt submitted to Ollama.
  show_model = false, -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false, -- Never closes the window automatically.
  -- init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
  command = [[curl --request POST \
  --url http://localhost:8080/v1/chat/completions \
  --header "Content-Type: application/json" \
  --data $body]], -- llamacpp server
  model_options = {
    temperature = 0,
    min_p = 0.2,
    n_predict = 512,
    stop = stop_words
  },
  -- list models works with ollama only
  list_models = '<omitted lua function>', -- Retrieves a list of model names
  debug = false -- Prints errors and the command which is run.
})

vim.keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')

-- Highlight colors {{{1
require('nvim-highlight-colors').setup {}

-- Image {{{1
-- https://github.com/3rd/image.nvim
if vim.fn.GetPlatform() == "nix" and (os.getenv("KITTY_WINDOW_ID") ~= nil or os.getenv("TERM_PROGRAM") == "WezTerm") and vim.g.vscode == nil and not vim.g.neovide then
    require("image").setup({})
end

-- Lazygit {{{1
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>')

-- Lsp {{{1
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Set client settings
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
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
    {
      name = "dictionary",
      keyword_length = 2,
    },
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

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local opts = { noremap=true, silent=true }
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Neotest {{{1
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-dotnet"),
    require("neotest-rust")
  },
})

vim.keymap.set('n', '<leader>tr', '<cmd>lua require("neotest").run.run()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ta', '<cmd>lua require("neotest").run.run({suite = true})<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tx', '<cmd>lua require("neotest").run.stop()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>td', '<cmd>lua require("neotest").run.attach()<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>td', '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>to', ':lua require("neotest").output.open({enter = true})<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ts', ':lua require("neotest").summary.toggle()<CR>', { noremap = true, silent = true })

-- Nvim devicons {{{1
require('nvim-web-devicons').setup({
  default = true
})

-- Nvim tree {{{1
require('nvim-tree').setup({
  update_cwd = false,
  filesystem_watchers = {
    enable = false,
    debounce_delay = 50,
    ignore_dirs = {
      "node_modules"
    },
  },
})

-- TabbyML {{{1
vim.g.tabby_keybinding_accept = '<C-g>'
vim.g.tabby_keybinding_trigger_or_dismiss = '<C-\\>'

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
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>')
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>')
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>')
vim.keymap.set('n', 'gR', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>')

-- vim: foldmethod=marker
-- EOF
