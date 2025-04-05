-- esabird/plugin/esabird.lua - Setup commands and mappings for Lua version

-- Prevent loading multiple times
if vim.g.loaded_esabird_lua then
  return
end
vim.g.loaded_esabird_lua = 1

local esabird = require('esabird')

-- Define user command
-- Usage: Select text in visual mode, then type :EsabirdSend
vim.api.nvim_create_user_command(
  'EsabirdSend',        -- Command name
  esabird.send_to_esa,  -- Function to call
  { range = true }      -- Indicate that the command accepts a range (like visual selection)
)

-- Define visual mode mapping
-- Usage: Select text in visual mode, then press <Leader>e (default)
-- Check if user wants default mappings
local no_default_mappings = vim.g.esabird_no_default_key_mappings or 0
if no_default_mappings == 0 then
  -- Get mapping key, default to <Leader>e
  local mapping_key = vim.g.esabird_mapping_key or '<Leader>e'
  -- Use vim.keymap.set for Neovim >= 0.7
  if vim.keymap and vim.keymap.set then
    vim.keymap.set('v', mapping_key, esabird.send_to_esa, { noremap = true, silent = true, desc = "Send selection to esa.io" })
  else -- Fallback for older Neovim versions (less common now)
    vim.api.nvim_set_keymap('v', mapping_key, ':lua require("esabird").send_to_esa()<CR>', { noremap = true, silent = true })
  end
end

-- Optional: Add setup function for more complex configuration later
-- function M.setup(opts)
--   -- Process options
-- end

print("Esabird (Lua) loaded.") -- Optional: confirmation message