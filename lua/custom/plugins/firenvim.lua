return {
  'glacambre/firenvim',
  lazy = not vim.g.started_by_firenvim,
  module = false,
  config = function()
    vim.g.firenvim_config = {
      globalSettings = {
        alt = 'all',
      },
      localSettings = {
        [ [[.*]] ] = {
          cmdline = 'neovim',
          priority = 0,
          selector = 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
          takeover = 'never',
        },
      },
    }
  end,
  build = function()
    vim.fn['firenvim#install'](0)
  end,
}
