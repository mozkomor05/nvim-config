return {
  'lervag/vimtex',
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_view_general_viewer = 'setsid zathura'
  end,
}
