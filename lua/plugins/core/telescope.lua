-- Telescope - Fuzzy Finder
-- Powerful fuzzy finder for files, grep, LSP, and more

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable telescope extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Telescope keymaps
    local builtin = require 'telescope.builtin'
    local map = vim.keymap.set

    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    map('n', '<leader>sc', builtin.command_history, { desc = '[S]earch [C]ommand History' })
    map('n', '<leader>sa', builtin.autocommands, { desc = '[S]earch [A]utocommands' })

    -- Find in current buffer
    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Search in open files
    map('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Search Neovim config files
    map('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- Git pickers
    map('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    map('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
    map('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
  end,
}
