return {
  'nvim-tree/nvim-tree.lua',
  denendencies = {
    'nvim-tree/nvim-web-devicons',
  },
  cond = not vim.g.started_by_firenvim,
  cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
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
    }

    local api = require 'nvim-tree.api'

    local git_add = function()
      local node = api.tree.get_node_under_cursor()
      local gs = node.git_status.file
      local dir = node.git_status.dir

      -- If the current node is a directory get children status
      if gs == nil and dir ~= nil then
        gs = (dir.direct ~= nil and dir.direct[1]) or (dir.indirect ~= nil and dir.indirect[1])
      end

      if gs == nil then
        return
      end

      -- If the file is untracked, unstaged or partially staged, we stage it
      if gs == '??' or gs == 'MM' or gs == 'AM' or gs == ' M' then
        vim.cmd('silent !git add ' .. node.absolute_path)

      -- If the file is staged, we unstage
      elseif gs == 'M ' or gs == 'A ' then
        vim.cmd('silent !git restore --staged ' .. node.absolute_path)
      end

      api.tree.reload()
    end

    vim.keymap.set('n', 'ga', git_add, { desc = '[G]it toggle [A]dd file' })
    vim.keymap.set('n', '<leader>nf', vim.cmd.NvimTreeFocus, { desc = '[N]vimTree [F]ocus' })
    vim.keymap.set('n', '<leader>no', vim.cmd.NvimTreeFindFile, { desc = '[N]vimTree [O]pen current file' })
    vim.keymap.set('n', '<leader>nt', function()
      require('nvim-tree.api').tree.toggle(false, true)
    end, { desc = '[N]vimTree [T]oggle' })
  end,
}
