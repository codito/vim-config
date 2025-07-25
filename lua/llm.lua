-- LLM plugins
-- Created: 01/09/2024, 10:26:27 +0530
-- Last modified: 17/07/2025, 06:46:06 +0530

local utils = require("util")

-- CodeCompanion {{{1
local default_adapter = "localai"
if utils.getPlatform() == "win" then
  default_adapter = "copilot"
end
require("codecompanion").setup({
  adapters = {
    opts = {
      -- show_defaults = false,
    },
    kimi = function()
      return require("codecompanion.adapters").extend("openai", {
        url = "https://api.groq.com/openai/v1/chat/completions",
        env = {
          api_key = "GROQ_API_KEY",
        },
        schema = {
          model = {
            default = "moonshotai/kimi-k2-instruct",
          },
          temperature = { default = 0.0 },
          max_tokens = { default = 1024 },
        },
        handlers = {
          form_messages = function(self, messages)
            -- Messages are of the form
            -- [{role: user, content: x, id: num, opts: {} }]
            -- Remove the `id` and `opts` params since Groq API is strict
            local formatted_messages = {}
            for i, message in ipairs(messages) do
              table.insert(formatted_messages, {
                role = message.role,
                content = message.content,
              })
            end
            return { messages = formatted_messages }
          end,
        },
      })
    end,
    qwq = function()
      return require("codecompanion.adapters").extend("openai", {
        url = "https://api.groq.com/openai/v1/chat/completions",
        env = {
          api_key = "GROQ_API_KEY",
        },
        schema = {
          model = {
            default = "qwen-qwq-32b",
          },
          temperature = { default = 0.0 },
          max_tokens = { default = 2048 },
        },
        handlers = {
          form_messages = function(self, messages)
            -- Messages are of the form
            -- [{role: user, content: x, id: num, opts: {} }]
            -- Remove the `id` and `opts` params since Groq API is strict
            local formatted_messages = {}
            for i, message in ipairs(messages) do
              table.insert(formatted_messages, {
                role = message.role,
                content = message.content,
              })
            end
            return { messages = formatted_messages }
          end,
        },
      })
    end,
    localai = function()
      return require("codecompanion.adapters").extend("openai", {
        url = "http://localhost:8080/v1/chat/completions",
        schema = {
          temperature = { default = 0.0 },
          max_tokens = { default = 512 },
        },
        handlers = {
          chat_output = function(self, data)
            local output = {}

            if data and data ~= "" then
              local data_mod = data:sub(7)
              local ok, json =
                pcall(vim.json.decode, data_mod, { luanil = { object = true } })

              if ok then
                if #json.choices > 0 then
                  local delta = json.choices[1].delta

                  if delta.content then
                    output.content = delta.content
                    output.role = delta.role or "assistant" -- llama-server doesn't return role on streaming

                    return {
                      status = "success",
                      output = output,
                    }
                  end
                end
              end
            end
          end,
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = default_adapter,
    },
    inline = { adapter = default_adapter },
    agent = { adapter = default_adapter },
  },
  display = {
    chat = {
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
      },
    },
    inline = {
      diff = {
        diff_method = "mini.diff",
      },
    },
  },
  opts = {
    force_role = true,
    -- log_level = "TRACE",
  },
})

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>ca",
  "<cmd>CodeCompanionActions<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<LocalLeader>ca",
  "<cmd>CodeCompanionActions<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>co",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<LocalLeader>co",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "ga",
  "<cmd>CodeCompanionChat Add<cr>",
  { noremap = true, silent = true }
)

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])

-- Copilot {{{1
if utils.getPlatform() == "win" then
  require("copilot").setup({
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = false,
      },
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
  })
end

-- Minuet {{{1
require("minuet").setup({
  provider = "openai_compatible",
  context_window = 4000, -- chars, ~3 char = ~1 token
  request_timeout = 3, -- in seconds
  n_completions = 1,
  provider_options = {
    openai_compatible = {
      model = "llama-3.1-70b-versatile",
      system = default_system,
      few_shots = default_few_shots,
      end_point = "https://api.groq.com/openai/v1/chat/completions",
      api_key = "GROQ_API_KEY",
      name = "Groq",
      stream = true,
      optional = {
        stop = nil,
        max_tokens = 256,
      },
    },
    -- openai_compatible = {
    --     end_point = "http://localhost:8080/v1/chat/completions",
    --     api_key = "SHELL", -- dummy key, must be a valid environment variable
    --     name = "local",
    --     stream = false,
    --     optional = {
    --         stop = nil,
    --         max_tokens = 256,
    --     },
    -- },
    -- openai_fim_compatible = {
    --     end_point = "http://localhost:8080/completion",
    --     api_key = "SHELL", -- dummy key, must be a valid environment variable
    --     name = "local-fim",
    --     stream = false,
    --     optional = {
    --         stop = { '\n\n' },
    --         max_tokens = 256,
    --     },
    -- }
  },
})

-- vim: foldmethod=marker foldmarker={{{,}}} ts=2 sw=2 et
-- EOF
