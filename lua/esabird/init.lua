-- esabird/init.lua - Send selected text to esa.io (Lua version for Neovim)

local M = {}

-- Helper function to get selected text
-- Based on Neovim's Lua API for visual selection
local function get_selected_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  local start_col = start_pos[3]
  local end_col = end_pos[3]
  local visual_mode = vim.fn.visualmode() -- 'v', 'V', or '<C-v>'

  if start_line == 0 or end_line == 0 then
    return "" -- No visual selection marks
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if #lines == 0 then
    return ""
  end

  if visual_mode == 'v' then -- Character-wise
    if #lines == 1 then
      lines[1] = string.sub(lines[1], start_col, end_col)
    else
      lines[1] = string.sub(lines[1], start_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return table.concat(lines, "\n")
  elseif visual_mode == 'V' then -- Line-wise
    return table.concat(lines, "\n")
  elseif visual_mode == '\22' then -- Block-wise (Ctrl-V, represented as \22)
    vim.notify("Esabird: Block selection not fully supported yet.", vim.log.levels.WARN)
    return ""
  else
    return ""
  end
end

-- Function to send selected text to esa.io
function M.send_to_esa()
  local selected_text = get_selected_text()
  if selected_text == "" then
    vim.notify("Esabird: No text selected.", vim.log.levels.ERROR)
    return
  end

  local api_token = os.getenv("ESA_API_TOKEN")
  local team_name = os.getenv("ESABIRD_TEAM_NAME")

  if not api_token or api_token == "" then
    vim.notify("Esabird: Environment variable ESA_API_TOKEN is not set.", vim.log.levels.ERROR)
    return
  end
  if not team_name or team_name == "" then
    vim.notify("Esabird: Environment variable ESABIRD_TEAM_NAME is not set.", vim.log.levels.ERROR)
    return
  end

  local api_url = string.format('https://api.esa.io/v1/teams/%s/posts', team_name)

  -- Extract title from H1 if present
  local post_title = "New post from Neovim (" .. os.date('%Y-%m-%d %H:%M') .. ")"
  local body_lines = vim.split(selected_text, "\n", { plain = true })
  if #body_lines > 0 and string.match(body_lines[1], "^#%s+(.+)") then
    post_title = string.match(body_lines[1], "^#%s+(.+)")
    table.remove(body_lines, 1) -- Remove H1 line from body
    selected_text = table.concat(body_lines, "\n")
  end

  -- Prepend timestamp to the body
  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local body_with_timestamp = timestamp .. "\n\n" .. selected_text

  local payload = {
    post = {
      name = post_title,
      body_md = body_with_timestamp, -- Use modified body
      wip = true,
    },
  }

  local ok, json_payload = pcall(vim.json.encode, payload)
  if not ok then
    vim.notify("Esabird: Failed to encode JSON payload.", vim.log.levels.ERROR)
    vim.notify(json_payload, vim.log.levels.ERROR)
    return
  end

  -- Use a list of arguments for vim.fn.system for safer execution
  local args = {
    'curl',
    '-s', -- Silent mode
    '-X', 'POST',
    api_url,
    '-H', string.format('Authorization: Bearer %s', api_token), -- Authorization header
    '-H', 'Content-Type: application/json', -- Content-Type header
    '-d', json_payload -- Request body data
  }

  vim.notify("Esabird: Sending to esa.io...", vim.log.levels.INFO)
  -- Execute the command using the argument list
  local result = vim.fn.system(args)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    vim.notify(string.format("Esabird: Failed to send. Curl error code: %d", exit_code), vim.log.levels.ERROR)
    -- Avoid logging the full command with the token in production environments if possible
    -- For debugging, you might temporarily log vim.inspect(args)
    vim.notify(string.format("Result: %s", result), vim.log.levels.DEBUG)
  else
    local ok_decode, response_data = pcall(vim.json.decode, result, { luanil = { object = true } })

    if not ok_decode or type(response_data) ~= 'table' then
      vim.notify("Esabird: Failed to decode JSON response or unexpected format.", vim.log.levels.ERROR)
      vim.notify(result, vim.log.levels.ERROR)
    elseif response_data.error then
      vim.notify(string.format("Esabird: API Error - %s: %s", response_data.error, response_data.message or "Unknown error"), vim.log.levels.ERROR)
    elseif response_data.url then
      vim.notify("Esabird: Successfully sent to esa.io!", vim.log.levels.INFO)
      vim.notify("Post URL: " .. response_data.url, vim.log.levels.INFO)
    else
      vim.notify("Esabird: Sent, but could not confirm success from response.", vim.log.levels.WARN)
      vim.notify(result, vim.log.levels.DEBUG)
    end
  end
end

return M