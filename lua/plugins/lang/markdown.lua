-- Markdown Support
-- Markdown preview (maintained fork of iamcco/markdown-preview.nvim)

return {
  'selimacerbas/markdown-preview.nvim',
  dependencies = { 'selimacerbas/live-server.nvim' },
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  keys = {
    { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = '[M]arkdown [P]review' },
  },
}
