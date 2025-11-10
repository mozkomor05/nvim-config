# Neovim Configuration

Modern, modular Neovim configuration with best practices and quality of life improvements.

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point (20 lines)
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Core keybindings  
│   │   ├── autocmds.lua        # Autocommands
│   │   └── lazy.lua            # Plugin manager
│   └── plugins/                # Plugin specifications
│       ├── core/               # LSP, completion, treesitter, telescope
│       ├── ui/                 # Theme, statusline, file tree
│       ├── tools/              # Git, formatting, linting, debugging
│       └── lang/               # Language-specific plugins
```

## Features

- Full LSP support with Mason
- Smart completion with snippets
- Fuzzy finding with Telescope
- Git integration (gitsigns + fugitive)
- Modern syntax highlighting (treesitter)
- Auto-formatting and linting
- Debugging support (DAP)
- GitHub Copilot
- Quality of life improvements

## Leader Key: `<Space>`

## Requirements

- Neovim >= 0.10
- Git, ripgrep, a C compiler
- Node.js (for some plugins)
- Nerd Font (recommended)
