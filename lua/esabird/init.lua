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
      -- Adjust end_col for multibyte characters if necessary (simplified here)
      lines[1] = string.sub(lines[1], start_col, end_col)
    else
      lines[1] = string.sub(lines[1], start_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return table.concat(lines, "\n")
  elseif visual_mode == 'V' then -- Line-wise
    return table.concat(lines, "\n")
  elseif visual_mode == '\22' then -- Block-wise (Ctrl-V, represented as \22)
    -- TODO: Handle block selection if needed
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

  -- Get configuration from global variables
  local api_token = vim.g.esabird_api_token
  local team_name = vim.g.esabird_team_name

  if not api_token or api_token == "" then
    vim.notify("Esabird: API token (vim.g.esabird_api_token) is not set.", vim.log.levels.ERROR)
    return
  end
  if not team_name or team_name == "" then
    vim.notify("Esabird: Team name (vim.g.esabird_team_name) is not set.", vim.log.levels.ERROR)
    return
  end

  local api_url = string.format('https://api.esa.io/v1/teams/%s/posts', team_name)

  -- Prepare JSON payload
  -- Basic escaping for JSON string values
  local escaped_text = selected_text:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n')

  -- TODO: Make post title configurable
  local post_title = "New post from Neovim (" .. os.date('%Y-%m-%d %H:%M') .. ")"
  local json_payload = string.format('{"post": {"name": "%s", "body_md": "%s", "wip": true}}', post_title, escaped_text)

  -- Build curl command
  -- Use vim.fn.shellescape for proper argument escaping
  local curl_command = string.format(
    'curl -s -X POST %s -H "Authorization: Bearer %s" -H "Content-Type: application/json" -d %s',
    api_url,
    api_token,
    vim.fn.shellescape(json_payload)
  )

  -- Execute curl command using vim.fn.system
  vim.notify("Esabird: Sending to esa.io...", vim.log.levels.INFO)
  local result = vim.fn.system(curl_command)
  local exit_code = vim.v.shell_error

  -- Check result
  if exit_code ~= 0 then
    vim.notify(string.format("Esabird: Failed to send. Curl error code: %d", exit_code), vim.log.levels.ERROR)
    vim.notify(string.format("Command: %s", curl_command), vim.log.levels.DEBUG)
    vim.notify(string.format("Result: %s", result), vim.log.levels.DEBUG)
  else
    -- Check if the response contains the post URL, indicating success
    if not result:match('"url":') then
       vim.notify("Esabird: Failed to send or unexpected response. Check response:", vim.log.levels.ERROR)
       vim.notify(result, vim.log.levels.ERROR)
    else
       vim.notify("Esabird: Successfully sent to esa.io!", vim.log.levels.INFO)
       -- Extract and potentially show the URL (optional improvement)
       -- local post_url = result:match('"url":"([^"]+)"')
       -- if post_url then vim.notify("Post URL: " .. post_url, vim.log.levels.INFO) end
       -- vim.notify(result, vim.log.levels.DEBUG) -- Uncomment for debugging response
    end
  end
end

return M