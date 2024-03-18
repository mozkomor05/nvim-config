-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return { -- Catppuccin theme
  'catppuccin/nvim',
  name = 'catppuccin',
  cond = function()
    return vim.fn.getenv 'TERM' ~= 'linux'
  end,
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      term_colors = true,
      integrations = {
        cmp = true,
        nvimtree = true,
        telescope = true,
        which_key = true,
        treesitter = true,
        fidget = true,
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
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
