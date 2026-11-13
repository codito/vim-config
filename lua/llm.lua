-- LLM plugins
-- Created: 01/09/2024, 10:26:27 +0530
-- Last modified: 13/11/2026, 16:45:30 +0530

-- Minuet {{{1
require("minuet").setup({
  provider = "codestral",
  context_window = 4000, -- chars, ~3 char = ~1 token
  request_timeout = 3, -- in seconds
  n_completions = 1,
  provider_options = {
    openai_compatible = {
      model = "qwen/qwen3.8-27b",
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
    gemini = {
      model = "gemini-3.8-flash",
      optional = {
        generationConfig = {
          maxOutputTokens = 256,
          -- When using `gemini-2.5-flash`, it is recommended to entirely
          -- disable thinking for faster completion retrieval.
          thinkingConfig = {
            thinkingBudget = 0,
          },
        },
        safetySettings = {
          {
            -- HARM_CATEGORY_HATE_SPEECH,
            -- HARM_CATEGORY_HARASSMENT
            -- HARM_CATEGORY_SEXUALLY_EXPLICIT
            category = "HARM_CATEGORY_DANGEROUS_CONTENT",
            -- BLOCK_NONE
            threshold = "BLOCK_ONLY_HIGH",
          },
        },
      },
    },
    codestral = {
      optional = {
        max_tokens = 256,
        stop = { "\n\n" }, -- ensure model output is trimmed
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
  virtualtext = {
    auto_trigger_ft = {
      "python",
      "rust",
      "javascript",
      "typescript",
      "typescriptreact",
      "css",
      "astro",
    },
    keymap = {
      -- accept whole completion
      accept = "<M-l>",
      -- accept one line
      accept_line = "<M-a>",
      -- accept n lines (prompts for number)
      -- e.g. "A-z 2 CR" will accept 2 lines
      accept_n_lines = "<M-z>",
      -- Cycle to prev completion item, or manually invoke completion
      prev = "<M-[>",
      -- Cycle to next completion item, or manually invoke completion
      next = "<M-]>",
      dismiss = "<M-e>",
    },
  },
})

-- vim: foldmethod=marker foldmarker={{{,}}} ts=2 sw=2 et
-- EOF
