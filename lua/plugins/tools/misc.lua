-- Miscellaneous Tools
-- Collection of smaller utility plugins

return {
  -- Detect tabstop and shiftwidth automatically (more modern than vim-sleuth)
  { 'NMAC427/guess-indent.nvim', opts = {} },

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
    dependencies = { 'copilotlsp-nvim/copilot-lsp' },
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
        yaml = true,
      },
    },
  },

  -- Mini.nvim modules
  {
    'echasnovski/mini.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Better Around/Inside textobjects
      -- around_next/inside_next remapped to avoid conflict with treesitter incremental selection (nvim>=0.12)
      require('mini.ai').setup {
        n_lines = 500,
        mappings = { around_next = 'aa', inside_next = 'ii' },
      }

      -- Add/delete/replace surroundings
      require('mini.surround').setup()

      -- Mini pairs for auto-pairing brackets
      require('mini.pairs').setup()
    end,
  },
}
