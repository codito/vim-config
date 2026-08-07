-- Debug configuration
-- Created: 08/09/2024
-- Last modified: 26/04/2026, 00:15:18 +0530
--
-- References
-- https://github.com/ryan-tin/neovim-config/blob/master/plugin/dap.lua
-- https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/dap.lua

local dap, dv = require("dap"), require("dap-view")
dap.listeners.before.attach["dap-view-config"] = function()
  dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
  dv.open()
end
dap.listeners.before.event_terminated["dap-view-config"] = function()
  dv.close()
end
dap.listeners.before.event_exited["dap-view-config"] = function()
  dv.close()
end

-- Utilities {{{1
local get_python_path = function()
  -- Use the python from Mason's debugpy install dir
  -- https://vi.stackexchange.com/questions/44606/how-can-i-used-mason-installed-debugpy-with-nvim-dap-python
  local python_path = table
    .concat({
      vim.fn.stdpath("data"),
      "mason",
      "packages",
      "debugpy",
      "venv",
      "bin",
      "python",
    }, "/")
    :gsub("//+", "/")
  return python_path
end

-- DAP UI {{{1
require("dap-view").setup({
  virtual_text = {
    -- Control with `DapViewVirtualTextToggle`
    enabled = true,
  },
})

-- Decides when and how to jump when stopping at a breakpoint
-- The order matters!
--
-- (1) If the line with the breakpoint is visible, don't jump at all
-- (2) If the buffer is opened in a tab, jump to it instead
-- (3) Else, create a new tab with the buffer
--
-- This avoid unnecessary jumps
-- See https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/nvim-dap.lua
dap.defaults.switchbuf = "usevisible,usetab,uselast"

-- DAP Keymaps {{{1
vim.keymap.set("n", "<F10>", '<cmd>lua require"dap".step_over()<CR>')
vim.keymap.set("n", "<F11>", '<cmd>lua require"dap".step_into()<CR>')
vim.keymap.set("n", "<F12>", '<cmd>lua require"dap".step_out()<CR>')
vim.keymap.set("n", "<F5>", '<cmd>lua require"dap".continue()<CR>')
vim.keymap.set("n", "<S-F5>", '<cmd>lua require"dap".terminate()<CR>')
vim.keymap.set("n", "<C-F10>", '<cmd>lua require"dap".run_to_cursor()<CR>')
vim.keymap.set("n", "<F9>", '<cmd>lua require"dap".toggle_breakpoint()<CR>')
vim.keymap.set(
  "n",
  "<C-F9>",
  '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>'
)

-- vim.keymap.set("n", "<F3>", '<cmd>lua require"dapui".float_element()<CR>')
-- vim.keymap.set("n", "<F4>", '<cmd>lua require"dapui".eval()<CR>')
-- vim.keymap.set(
--   "n",
--   "<F8>",
--   '<cmd>lua require"dapui".elements.watches.add()<CR>'
-- )
-- vim.keymap.set("n", "<F6>", '<cmd>lua require"dapui".toggle()<CR>')

-- DAP Adapters {{{1
-- Python {{{2
require("dap-python").setup(get_python_path())
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    justMyCode = false,
    cwd = vim.fn.getcwd(),
    program = "${file}",
    console = "integratedTerminal",
    pythonPath = get_python_path(),
  },
  {
    type = "python",
    request = "launch",
    name = "Launch Module",
    justMyCode = false,
    module = function()
      return string.gsub(vim.fn.expand("%:.:r"), "/", ".")
    end,
    console = "integratedTerminal",
    pythonPath = get_python_path(),
  },
  {
    type = "python",
    request = "attach",
    name = "Attach remote",
    justMyCode = false,
    pythonPath = get_python_path(),
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      return tonumber(vim.fn.input("Port [5678]: ")) or 5678
    end,
  },
}

-- Typescript {{{2
-- Function to find the closest package.json file
-- Credit: https://github.com/Notaduck/kickstart.nvim/blob/master/lua/plugins/npm_debug.lua
local function find_package_json()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  local package_json_path = ""

  -- Traverse up directories until a package.json is found
  while current_dir ~= "/" do
    local potential_path = current_dir .. "/package.json"
    if vim.fn.filereadable(potential_path) == 1 then
      package_json_path = potential_path
      break
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return package_json_path
end

-- Function to parse package.json and extract npm scripts
local function get_npm_scripts()
  local package_json_path = find_package_json()
  if package_json_path == "" then
    vim.notify("No package.json found", vim.log.levels.ERROR)
    return {}
  end

  local package_json_content = vim.fn.readfile(package_json_path)
  local package_json = vim.fn.json_decode(package_json_content)

  if not package_json or not package_json.scripts then
    vim.notify("No scripts found in package.json", vim.log.levels.ERROR)
    return {}
  end

  local scripts = {}
  for name, command in pairs(package_json.scripts) do
    table.insert(scripts, { name = name, command = command })
  end

  return scripts, package_json_path
end

for _, js_adapter in pairs({ "pwa-node", "pwa-chrome" }) do
  dap.adapters[js_adapter] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = { "${port}" },
    },
  }
end

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch NPM Script",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "npm",
      runtimeArgs = function()
        scripts, _ = get_npm_scripts()
        run_args = {}
        for i, script in ipairs(scripts) do
          if script ~= nil then
            table.insert(run_args, script.name)
          end
        end

        choice = vim.fn.inputlist(run_args)
        return { "run", run_args[choice] }
      end,
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  }
end

-- Rust {{{2
-- See https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}
dap.adapters.rust = dap.adapters.codelldb

dap.configurations.rust = {
  {
    type = "rust",
    request = "launch",
    name = "codelldb",
    program = function()
      -- build the binary
      local build =
        vim.fn.systemlist("cargo build -q --message-format=json 2>1")
      local metadata_json =
        vim.fn.system("cargo metadata --format-version 1 --no-deps")
      local metadata = vim.fn.json_decode(metadata_json)
      local target_dir = metadata.target_directory
      programs = {}
      for _, p in ipairs(metadata.packages) do
        local target_name = p.targets[1].name
        if target_name ~= nil then
          table.insert(programs, target_dir .. "/debug/" .. target_name)
        end
      end

      choice = vim.fn.inputlist(programs)
      return vim.fn.resolve(programs[choice])
    end,
  },
}

-- vim: foldmethod=marker fileformat=unix foldmarker={{{,}}}
-- EOF
