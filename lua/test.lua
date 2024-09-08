-- Debug configuration
-- Created: 08/09/2024, 21:45:03 +0530
-- Last modified: 08/09/2024, 21:47:18 +0530

-- Coverage {{{1
require("coverage").setup({
  auto_reload = true,
})

-- Neotest {{{1
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-dotnet"),
    require("neotest-rust"),
  },
})

vim.keymap.set(
  "n",
  "<leader>tr",
  '<cmd>lua require("neotest").run.run()<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>tf",
  '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>ta",
  '<cmd>lua require("neotest").run.run({suite = true})<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>tx",
  '<cmd>lua require("neotest").run.stop()<CR>',
  { noremap = true, silent = true }
)
-- vim.keymap.set(
--   "n",
--   "<leader>td",
--   '<cmd>lua require("neotest").run.attach()<CR>',
--   { noremap = true, silent = true }
-- )
vim.keymap.set(
  "n",
  "<leader>td",
  '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>to",
  ':lua require("neotest").output.open({enter = true})<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>ts",
  ':lua require("neotest").summary.toggle()<CR>',
  { noremap = true, silent = true }
)

-- vim: foldmethod=marker fileformat=unix foldmarker={{{,}}}
-- EOF
