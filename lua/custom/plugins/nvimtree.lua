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

    vim.keymap.set('n', '<leader>nf', vim.cmd.NvimTreeFocus, { desc = '[N]vimTree [F]ocus' })
    vim.keymap.set('n', '<leader>no', vim.cmd.NvimTreeFindFile, { desc = '[N]vimTree [O]pen current file' })
    vim.keymap.set('n', '<leader>nt', function()
      require('nvim-tree.api').tree.toggle(false, true)
    end, { desc = '[N]vimTree [T]oggle' })
  end,
}
