-- ============================================================================
-- Neovim Configuration
-- ============================================================================
-- Entry point for Neovim configuration
--
-- Structure:
--   lua/config/       - Core configuration (options, keymaps, autocmds)
--   lua/plugins/core/ - Essential plugins (LSP, completion, treesitter)
--   lua/plugins/ui/   - UI enhancements (theme, statusline, file tree)
--   lua/plugins/tools/- Development tools (git, formatting, debugging)
--   lua/plugins/lang/ - Language-specific plugins
-- ============================================================================

-- Load core configuration
require 'config.options' -- Vim options and settings
require 'config.lazy' -- Plugin manager setup
require 'config.autocmds' -- Autocommands
require 'config.keymaps' -- Core keymaps
-- vim: ts=2 sts=2 sw=2 et
