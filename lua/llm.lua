-- LLM plugins
-- Created: 01/09/2024, 10:26:27 +0530
-- Last modified: 01/09/2024, 22:08:33 +0530

-- CodeCompanion {{{1
require("codecompanion").setup({
    adapters = {
        openai = function()
            return require("codecompanion.adapters").extend("openai", {
                url = "http://localhost:8080/v1/chat/completions"
            })
        end,
    },
})

vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>co", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<LocalLeader>co", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Minuet {{{1
require('minuet').setup({
    provider = "openai_compatible",
    context_window = 4000, -- chars, ~3 char = ~1 token
    request_timeout = 3, -- in seconds
    n_completions = 1,
    provider_options = {
        openai_compatible = {
            model = 'llama-3.1-70b-versatile',
            system = default_system,
            few_shots = default_few_shots,
            end_point = 'https://api.groq.com/openai/v1/chat/completions',
            api_key = 'GROQ_API_KEY',
            name = 'Groq',
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
    }
})

-- vim: foldmethod=marker foldmarker={{{,}}}
-- EOF
