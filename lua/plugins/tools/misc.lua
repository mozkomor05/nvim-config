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
      {
        '<leader>u',
        function()
          require('undotree').toggle()
        end,
        desc = 'Toggle [U]ndotree',
      },
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
    'nvim-mini/mini.nvim', -- upstream moved from echasnovski/ to the nvim-mini org
    -- NOT lazy: mini.icons has to install its nvim-web-devicons shim before any
    -- icon consumer (nvim-tree, telescope, lualine, lazy's own UI) first requires
    -- it. priority keeps it ahead of the other eager plugins; the colorscheme
    -- still wins at 1000.
    lazy = false,
    priority = 900,
    config = function()
      -- Icon provider. Resolves via vim.filetype.match() rather than hardcoded
      -- filename/extension tables, and uses highlight groups linked to built-ins
      -- so icons follow the colorscheme instead of shipping fixed hex colors.
      require('mini.icons').setup {
        style = vim.g.have_nerd_font and 'glyph' or 'ascii',
      }
      -- Third-party plugins only know about nvim-web-devicons; this registers a
      -- stand-in for it so they get mini's icons. It is what lets us drop the
      -- nvim-web-devicons dependency entirely.
      MiniIcons.mock_nvim_web_devicons()

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
