# Esabird

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A simple Vim/Neovim plugin to send selected text directly to your [esa.io](https://esa.io/) team as a new post (WIP).

Supports both Vim script (for Vim 8.0+ and Neovim) and Lua (for Neovim 0.7+). Neovim will automatically prefer the Lua implementation if available.

## Features

*   Send selected text (visual mode) to esa.io as a new WIP post.
*   Works with both Vim and Neovim.
*   Configurable API token and team name.
*   Default mapping `<Leader>e` in visual mode.
*   User command `:EsabirdSend`.

## Requirements

*   Vim 8.0+ or Neovim 0.7+
*   `curl` command installed on your system.
*   An esa.io account and a personal access token.

## Installation

Use your favorite plugin manager.

**vim-plug**
```vim
Plug 'your-github-username/esabird' " Replace with actual path if hosted
```

**packer.nvim**
```lua
use 'your-github-username/esabird' -- Replace with actual path if hosted
```

**lazy.nvim**
```lua
{ 'your-github-username/esabird' } -- Replace with actual path if hosted
```

Or manually clone the repository into your Vim/Neovim package directory:
*   Vim: `~/.vim/pack/vendor/start/esabird`
*   Neovim: `~/.config/nvim/pack/vendor/start/esabird`

## Configuration

Add the following configuration to your Vim/Neovim setup:

**Vim (`.vimrc`) or Neovim (`init.vim`)**
```vim
" Required: Your esa.io personal access token
" Generate one from: https://<your-team>.esa.io/user/tokens
let g:esabird_api_token = 'YOUR_ESA_API_TOKEN'

" Required: Your esa.io team name
let g:esabird_team_name = 'YOUR_TEAM_NAME'

" Optional: Change the default mapping key (<Leader>e)
" let g:esabird_mapping_key = '<Leader>s' " Example: use <Leader>s

" Optional: Disable default key mapping if you want to set it manually
" let g:esabird_no_default_key_mappings = 1
```

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

Replace `'YOUR_ESA_API_TOKEN'` with your actual token and `'YOUR_TEAM_NAME'` with your team name.

## Usage

1.  Select text in Visual mode (character-wise `v` or line-wise `V`).
2.  Press `<Leader>e` (default mapping) or execute the command `:EsabirdSend`.
3.  The selected text will be posted to your configured esa.io team as a new WIP post. The post title includes the current timestamp.

Check Vim/Neovim messages for success or error notifications.

## Documentation

For more details, see the help file within Vim/Neovim:
```vim
:help esabird
```

## License

MIT License. See the `LICENSE` file for details (if one exists in the repository).