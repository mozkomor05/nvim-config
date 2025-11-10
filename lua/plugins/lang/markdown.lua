-- Markdown Support
-- Markdown preview plugin

return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  ft = 'markdown',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  keys = {
    { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = '[M]arkdown [P]review' },
  },
}
