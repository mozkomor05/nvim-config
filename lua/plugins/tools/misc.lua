-- Miscellaneous Tools
-- Collection of smaller utility plugins

return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Comment.nvim - Easy commenting
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- TODO: test
  -- BUG: i dont know
  -- @TODO: sth
  -- WARNING: WHY DOESNT IT WORK BROO

  -- Todo Comments - Highlight and search for todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
    },
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
    },
  },

  -- Undotree - Visualize undo history
  {
    'jiaoshijie/undotree',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    keys = {
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle [U]ndotree' },
    },
  },

  -- Copilot - AI pair programming
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<M-l>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },

  -- Mini.nvim modules
  {
    'echasnovski/mini.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings
      require('mini.surround').setup()

      -- Mini pairs for auto-pairing brackets
      require('mini.pairs').setup()
    end,
  },
}
