-- Nvim-tree - File Explorer
-- File tree with git integration (with security fixes)

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  keys = {
    { '<leader>nf', '<cmd>NvimTreeFocus<cr>', desc = '[N]vimTree [F]ocus' },
    { '<leader>no', '<cmd>NvimTreeFindFile<cr>', desc = '[N]vimTree [O]pen current file' },
    {
      '<leader>nt',
      function()
        require('nvim-tree.api').tree.toggle(false, true)
      end,
      desc = '[N]vimTree [T]oggle',
    },
  },
  config = function()
    require('nvim-tree').setup {
      disable_netrw = false,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
        side = 'left',
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { '.git', 'node_modules', '.cache' },
      },
    }

    local api = require 'nvim-tree.api'

    -- Git add/restore with security fixes
    local git_add = function()
      local node = api.tree.get_node_under_cursor()

      -- Security: Add nil checks to prevent crashes
      if not node or not node.git_status or not node.absolute_path then
        return
      end

      local gs = node.git_status.file
      local dir = node.git_status.dir

      -- Try to infer git status from directory
      if gs == nil and dir ~= nil then
        gs = (dir.direct and dir.direct[1]) or (dir.indirect and dir.indirect[1])
      end

      if gs == nil then
        return
      end

      -- Security fix: Use jobstart with list args to prevent command injection
      -- This prevents issues with filenames containing spaces or special characters
      local path = node.absolute_path

      if gs == '??' or gs == 'MM' or gs == 'AM' or gs == ' M' then
        -- Stage file (non-blocking, safe)
        vim.fn.jobstart({ 'git', 'add', path }, {
          detach = true,
          on_exit = function()
            vim.schedule(function()
              api.tree.reload()
            end)
          end,
        })
      elseif gs == 'M ' or gs == 'A ' then
        -- Unstage file (non-blocking, safe)
        vim.fn.jobstart({ 'git', 'restore', '--staged', path }, {
          detach = true,
          on_exit = function()
            vim.schedule(function()
              api.tree.reload()
            end)
          end,
        })
      end
    end

    -- Set up keymap in nvim-tree buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'NvimTree',
      callback = function()
        vim.keymap.set('n', 'ga', git_add, { buffer = true, desc = '[G]it toggle [A]dd file' })
      end,
    })
  end,
}
