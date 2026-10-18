-- LaTeX Support
-- VimTeX for LaTeX editing

return {
  'lervag/vimtex',
  -- VimTeX must not be lazy-loaded: it needs to own the `tex` filetype detection
  -- before any buffer is read. (`ft = 'tex'` here was dead -- lazy = false wins.)
  lazy = false,
  init = function()
    -- zathura/sioyek/mupdf on Linux, Skim on macOS, 'general' if none are installed
    vim.g.vimtex_view_method = require('config.machine').tex_viewer()
    vim.g.vimtex_compiler_method = 'latexmk'
  end,
}
