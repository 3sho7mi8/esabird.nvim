# Esabird

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A simple Neovim (0.7+) plugin, written in Lua, to send selected text directly to your [esa.io](https://esa.io/) team as a new post (WIP).

## Features

*   Send selected text (visual mode) to esa.io as a new WIP post.
*   Written in Lua for Neovim.
*   Configurable API token and team name.
*   Default mapping `<Leader>e` in visual mode.
*   User command `:EsabirdSend`.

## Requirements

*   Neovim 0.7+
*   `curl` command installed on your system.
*   An esa.io account and a personal access token.

## Installation

Use your favorite plugin manager.

(Plugin managers like packer.nvim or lazy.nvim are recommended for Neovim)

**packer.nvim**
```lua
use 'your-github-username/esabird' -- Replace with actual path if hosted
```

**lazy.nvim**
```lua
{ 'your-github-username/esabird' } -- Replace with actual path if hosted
```

Or manually clone the repository into your Neovim package directory:
*   Neovim: `~/.config/nvim/pack/vendor/start/esabird`

## Configuration

Add the following configuration to your Neovim setup (`init.lua`):

**Neovim (`init.lua`)**
```lua
-- Required: Your esa.io personal access token
-- Generate one from: https://<your-team>.esa.io/user/tokens
vim.g.esabird_api_token = 'YOUR_ESA_API_TOKEN'

-- Required: Your esa.io team name
vim.g.esabird_team_name = 'YOUR_TEAM_NAME'

-- Optional: Change the default mapping key (<Leader>e)
-- vim.g.esabird_mapping_key = '<Leader>s' -- Example: use <Leader>s

-- Optional: Disable default key mapping if you want to set it manually
-- vim.g.esabird_no_default_key_mappings = 1
```

Replace `'YOUR_ESA_API_TOKEN'` with your actual token and `'YOUR_TEAM_NAME'` with your team name in your `init.lua`.

## Usage

1.  Select text in Visual mode (character-wise `v` or line-wise `V`).
2.  Press `<Leader>e` (default mapping) or execute the command `:EsabirdSend`.
3.  The selected text will be posted to your configured esa.io team as a new WIP post. The post title includes the current timestamp.

Check Neovim messages (using `vim.notify`) for success or error notifications.

## Documentation

For more details, see the help file within Neovim:
```vim
:help esabird
```

## License

MIT License. See the `LICENSE` file for details (if one exists in the repository).