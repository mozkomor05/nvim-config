-- Markdown Support
-- Markdown preview with Mermaid/KaTeX support. mdkite.nvim was called
-- markdown-preview.nvim (and its server kitehost.nvim was live-server.nvim)
-- before 2.0; the old names and :MarkdownPreview* commands go away in 3.0.

return {
  -- mdkite's own lazy.lua declares kitehost as a top-level spec, which would
  -- make it load eagerly (and print "kitehost: stopped all instances" on every
  -- quit); mark it lazy so it only loads together with mdkite.
  { 'selimacerbas/kitehost.nvim', lazy = true },
  {
    'selimacerbas/mdkite.nvim',
    dependencies = { 'selimacerbas/kitehost.nvim' },
    cmd = 'MdKite',
    keys = {
      { '<leader>mp', '<cmd>MdKite toggle<cr>', desc = '[M]arkdown [P]review' },
    },
    config = function()
      require('mdkite').setup {}
    end,
  },
}
