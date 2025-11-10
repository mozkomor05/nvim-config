-- Firenvim - Neovim in Browser
-- Embed Neovim in your browser's textarea

return {
  'glacambre/firenvim',
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn['firenvim#install'](0)
  end,
  config = function()
    vim.g.firenvim_config = {
      globalSettings = { alt = 'all' },
      localSettings = {
        ['.*'] = {
          cmdline = 'neovim',
          content = 'text',
          priority = 0,
          selector = 'textarea',
          takeover = 'never',
        },
      },
    }

    -- Firenvim-specific settings
    if vim.g.started_by_firenvim then
      vim.o.laststatus = 0
      vim.o.guifont = 'monospace:h12'
    end
  end,
}
