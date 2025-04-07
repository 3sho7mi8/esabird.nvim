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
    -- No specific plugin configuration needed here anymore.
    -- API token and team name are read from environment variables.

    -- Example keymap (Visual mode)
    vim.keymap.set('v', '<leader>es', require('esabird').send_to_esa, { desc = 'Send selection to esa.io' })
  end,
}
```

## Configuration

This plugin reads the necessary configuration directly from environment variables. You **do not** need to set any `vim.g` variables in your Neovim configuration (`init.lua` or `init.vim`) for this plugin.

Instead, you must configure the following environment variables in your shell's startup file (e.g., `~/.zshrc`, `~/.bashrc`, `~/.profile`, or `~/.config/fish/config.fish`):

1.  **`ESA_API_TOKEN`**: Your personal access token for the esa.io API.
    *   You can generate one from your esa.io settings: [Personal Access Tokens](https://docs.esa.io/posts/102).
    *   Add the following line to your shell configuration file, replacing `"YOUR_ACTUAL_ESA_API_TOKEN"` with the token you generated:
        ```sh
        # Example for .zshrc or .bashrc
        export ESA_API_TOKEN="YOUR_ACTUAL_ESA_API_TOKEN"
        ```

2.  **`ESABIRD_TEAM_NAME`**: Your esa.io team name.
    *   This is the subdomain part of your esa.io URL (e.g., if your URL is `myteam.esa.io`, the team name is `myteam`).
    *   Add the following line to your shell configuration file, replacing `"your-team-name"` with your actual team name:
        ```sh
        # Example for .zshrc or .bashrc
        export ESABIRD_TEAM_NAME="your-team-name"
        ```

**Important:**
*   After editing your shell configuration file, you must either **restart your terminal/shell session** or **source the configuration file** (e.g., run `source ~/.zshrc`) for the changes to take effect.
*   Ensure that you launch Neovim from a shell session where these environment variables are correctly set and exported. You can verify this by running `echo $ESA_API_TOKEN` and `echo $ESABIRD_TEAM_NAME` in the terminal before starting Neovim.

## Usage

1. Select text in Neovim using visual mode (`v`, `V`).
2. Press the configured keymap (e.g., `<leader>es`) or run the command `:lua require('esabird').send_to_esa()`.
3. On success, a notification will appear showing the URL of the created post.

## Notes

- Block selection (`<C-v>`) is currently not supported.
- If an error occurs, a message will be displayed in the Neovim notification area.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details (if one exists).
