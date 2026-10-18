-- Lualine - Status Line
-- Fast and extensible statusline

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-mini/mini.nvim', 'catppuccin/nvim' }, -- mini.nvim provides the icons
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'auto', -- follows the active colorscheme instead of pinning a flavour
      icons_enabled = vim.g.have_nerd_font,
      component_separators = '|',
      section_separators = '',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'filename',
          path = 1, -- Relative path
        },
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
