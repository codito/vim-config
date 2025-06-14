-- NVIM lua config
-- Created: 11/12/2021, 11:44:11 +0530
-- Last modified: 13/06/2025, 15:55:54 +0530

-- Include other configurations
require("ui") -- UI settings
require("edit") -- Editor setup
require("diag") -- Debugger, DAP setup
require("test") -- Test run, coverage configurations
require("llm") -- AI and LLM configurations

local utils = require("util")

-- Aerial {{{1
-- Symbols outliner for neovim
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "<leader>[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "<leader>]", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>tt", "<cmd>AerialToggle! right<CR>")

-- Comment {{{1
require("Comment").setup()

-- Conform {{{1
require("conform").setup({
  formatters_by_ft = {
    css = { "stylelint" },
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "ruff_format", "ruff_organize_imports" },
    -- Use a sub-list to run only the first available formatter
    astro = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
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

-- Highlight colors {{{1
require("nvim-highlight-colors").setup({})

-- Image {{{1
-- https://github.com/3rd/image.nvim
if
  utils.getPlatform() == "nix"
  and (os.getenv("KITTY_WINDOW_ID") ~= nil or os.getenv("TERM_PROGRAM") == "WezTerm")
  and (not vim.g.vscode or vim.g.vscode == false)
  and (not vim.g.neovide or vim.g.neovide == false)
then
  require("image").setup({
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = false, -- if true, images will be rendered in floating markdown windows
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
    },
    tmux_show_only_in_active_window = true, -- needs visual-activity off
  })
end

-- Lsp {{{1
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Set client settings
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end

local cmp = require("blink.cmp")
local luasnip = require("luasnip")
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end
cmp.setup({
  enabled = function()
    -- Disable blink.cmp for dap-repl. See https://github.com/Saghen/blink.cmp/issues/1495
    return not vim.tbl_contains({ "dap-repl" }, vim.bo.filetype)
  end,
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<A-y>"] = require("minuet").make_blink_map(),
  },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  -- Disable cmdline, stop completions in popups and cmd
  cmdline = { enabled = false },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    documentation = { auto_show = false },
    trigger = { prefetch_on_insert = false },
    list = {
      selection = { preselect = true, auto_insert = true },
    },
  },

  snippets = { preset = "luasnip" },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "emoji", "latex_symbols" },
    providers = {
      emoji = {
        name = "emoji",
        module = "blink.compat.source",
      },
      latex_symbols = {
        name = "latex_symbols",
        module = "blink.compat.source",
      },
      minuet = { -- manual complete only
        name = "minuet",
        module = "minuet.blink",
        score_offset = 8, -- Gives minuet higher priority among suggestions
      },
    },
  },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Configure the installed lsp servers.
-- lsp_installer setup must be called before lspconfig.
require("mason").setup()
local lsp_installer = require("mason-lspconfig")
lsp_installer.setup()

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup({
  ensure_installed = {
    "astro",
    "basedpyright",
    "csharp_ls",
    "cssls",
    -- "harper_ls",
    "html",
    "jsonls",
    "marksman",
    "ruff",
    "ts_ls",
    "yamlls",
  },
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
})

-- require("lspconfig").harper_ls.setup({
--   settings = {
--     ["harper-ls"] = {
--       linters = {
--         SpellCheck = false,
--       },
--     },
--   },
-- })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local opts = { noremap=true, silent=true }
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

-- Nvim devicons {{{1
require("nvim-web-devicons").setup({
  default = true,
})

-- Nvim tree {{{1
require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
  filesystem_watchers = {
    enable = false,
    debounce_delay = 50,
    ignore_dirs = {
      "node_modules",
    },
  },
  git = {
    enable = false,
  },
})

-- Telescope {{{1
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
vim.keymap.set("n", "<leader>kk", builtin.keymaps, {})
vim.keymap.set("n", "<leader>zz", builtin.spell_suggest, {})

vim.keymap.set("n", "<leader>xx", function()
  builtin.diagnostics({ sort_by = "severity" })
end, {})
vim.keymap.set("n", "<leader>xd", function()
  builtin.diagnostics({ bufnr = 0, sort_by = "severity" })
end, {})

vim.keymap.set("n", "<leader>ll", builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "<leader>ld", builtin.lsp_document_symbols, {})

require("telescope").setup({
  extensions = {
    file_browser = {
      git_status = false,
    },
  },
})

-- Tree sitter {{{1
-- https://github.com/nvim-treesitter/nvim-treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = { "markdown" },
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
    enable = true,
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
      border = "none",
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
})

-- Thesaurus {{{1
vim.cmd([[
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
]])
vim.opt.thesaurusfunc = "Thesaur"

function ShowSynonymsForWordUnderCursor()
  local word = vim.fn.expand("<cword>")
  vim.cmd("Thesaurus " .. word)
end

vim.keymap.set(
  "n",
  "<leader>ct",
  ShowSynonymsForWordUnderCursor,
  { noremap = true }
)

-- Toggleterm {{{1
require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-\>]],
  autochdir = true,
})

-- vim: foldmethod=marker foldmarker={{{,}}}
-- EOF
