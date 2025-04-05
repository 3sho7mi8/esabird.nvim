" esabird.vim - Send selected text to esa.io

" Function to send selected text to esa.io
function! esabird#send_to_esa(visual_mode) abort
  let selected_text = esabird#get_selected_text(a:visual_mode)
  if empty(selected_text)
    echoerr "No text selected."
    return
  endif

  " Check for required configuration
  if !exists('g:esabird_api_token') || empty(g:esabird_api_token)
    echoerr "esa.io API token (g:esabird_api_token) is not set."
    return
  endif
  if !exists('g:esabird_team_name') || empty(g:esabird_team_name)
    echoerr "esa.io team name (g:esabird_team_name) is not set."
    return
  endif

  let api_token = g:esabird_api_token
  let team_name = g:esabird_team_name
  let api_url = printf('https://api.esa.io/v1/teams/%s/posts', team_name)

  " Prepare JSON payload
  " Escape special characters for JSON string
  let escaped_text = substitute(selected_text, '\\', '\\\\', 'g')
  let escaped_text = substitute(escaped_text, '"', '\\"', 'g')
  let escaped_text = substitute(escaped_text, "\n", '\\n', 'g') " Escape newlines for JSON

  " TODO: Make post title configurable
  let post_title = "New post from Vim (" . strftime('%Y-%m-%d %H:%M') . ")"
  let json_payload = printf('{"post": {"name": "%s", "body_md": "%s", "wip": true}}', post_title, escaped_text)

  " Build curl command
  let curl_command = printf('curl -s -X POST %s -H "Authorization: Bearer %s" -H "Content-Type: application/json" -d %s',
        \ api_url, api_token, shellescape(json_payload))

  " Execute curl command
  echom "Sending to esa.io..."
  let result = system(curl_command)

  " Check result (basic check, might need improvement based on curl output)
  if v:shell_error
    echoerr "Failed to send to esa.io. Error: " . v:shell_error
    echom "Command executed: " . curl_command
    echom "Result: " . result
  else
    " TODO: Parse JSON response for better feedback (e.g., post URL)
    if result =~? 'error' || result =~? 'Not Found' " Basic error check in response
       echoerr "Failed to send to esa.io. Response: " . result
    else
       echom "Successfully sent to esa.io!"
       " echom "Response: " . result " Uncomment for debugging
    endif
  endif

endfunction

" Function to get selected text
function! esabird#get_selected_text(visual_mode) abort
  let [bufnum, start_line, start_col, end_col] = getpos("'<")
  let [_, end_line, _, _] = getpos("'>")

  if a:visual_mode ==# 'v' " Character-wise visual mode
    let lines = getline(start_line, end_line)
    if len(lines) == 1
      let lines[0] = lines[0][start_col-1 : end_col-1]
    else
      let lines[0] = lines[0][start_col-1 :]
      let lines[-1] = lines[-1][: end_col-1]
    endif
    return join(lines, "\n")
  elseif a:visual_mode ==# 'V' " Line-wise visual mode
    return join(getline(start_line, end_line), "\n")
  elseif a:visual_mode ==# "\<C-v>" " Block-wise visual mode
    " TODO: Handle block-wise visual mode if needed
    echom "Block-wise visual mode is not fully supported yet."
    return ''
  else
    return ''
  endif
endfunction