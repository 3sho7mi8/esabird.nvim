# esabird.nvim

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A simple Neovim plugin to send selected text to [esa.io](https://esa.io/).

## Features

- Send selected text in visual mode as a new post to esa.io.
- Posts are created as WIP (Work In Progress).

## Installation

Use your favorite plugin manager.

### lazy.nvim

```lua
{
  '3sho7mi8/esabird.nvim',
  config = function()
    -- Configuration (see below)
    vim.g.esabird_api_token = os.getenv("ESA_API_TOKEN") -- Example: Load from environment variable
    vim.g.esabird_team_name = "your-team-name"

    -- Example keymap (Visual mode)
    vim.keymap.set('v', '<leader>es', require('esabird').send_to_esa, { desc = 'Send selection to esa.io' })
  end,
}
```

## Configuration

Set the following global variables in your Neovim configuration file (e.g., `init.lua`).

- `vim.g.esabird_api_token`: Your esa.io API token. Generate a [Personal Access Token](https://docs.esa.io/posts/102) and set it. For security, loading from an environment variable is recommended.
- `vim.g.esabird_team_name`: Your esa.io team name (e.g., the `your-team-name` part of `your-team-name.esa.io`).

```lua
-- Example in init.lua
vim.g.esabird_api_token = "YOUR_ESA_API_TOKEN" -- or os.getenv("ESA_API_TOKEN")
vim.g.esabird_team_name = "your-team-name"
```

## Usage

1. Select text in Neovim using visual mode (`v`, `V`).
2. Press the configured keymap (e.g., `<leader>es`) or run the command `:lua require('esabird').send_to_esa()`.
3. On success, a notification will appear showing the URL of the created post.

## Notes

- Block selection (`<C-v>`) is currently not supported.
- If an error occurs, a message will be displayed in the Neovim notification area.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details (if one exists).
