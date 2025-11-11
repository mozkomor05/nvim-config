-- LaTeX Support
-- VimTeX for LaTeX editing

return {
  'lervag/vimtex',
  ft = 'tex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
  end,
}
