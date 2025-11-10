-- Catppuccin Theme
-- Beautiful pastel theme

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  cond = function()
    return vim.fn.getenv 'TERM' ~= 'linux'
  end,
  opts = {
    flavour = 'mocha',
    term_colors = true,
    transparent_background = false,
    dim_inactive = {
      enabled = false,
      shade = 'dark',
      percentage = 0.15,
    },
    integrations = {
      cmp = true,
      nvimtree = true,
      telescope = {
        enabled = true,
      },
      which_key = true,
      treesitter = true,
      fidget = true,
      gitsigns = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
        },
      },
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
