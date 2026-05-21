-- Highlight TODO / FIX / HACK / NOTE comments; navigate with ]t / [t; search with :TodoTelescope
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
    keywords = {
      FIX  = { icon = ' ', color = 'error',   alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ',                    alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint',    alt = { 'INFO' } },
      TEST = { icon = '⏲ ', color = 'test',   alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
  },
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odos' },
  },
}
