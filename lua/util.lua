-- Utility functions loaded on init. Please keep only minimal code.
-- Created: 29/09/2024, 21:03:26 +0530
-- Last updated: 29/09/2024, 21:06:21 +0530

local M = {}

-- Know the platform we're running on
function M.getPlatform()
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return "win"
  end

  return "nix"
end

return M
