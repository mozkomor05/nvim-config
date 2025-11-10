-- Autocommands Configuration
-- This file contains all autocommands for enhanced editor behavior

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  desc = 'Resize splits if window got resized',
  group = vim.api.nvim_create_augroup('resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close certain filetypes with q',
  group = vim.api.nvim_create_augroup('close-with-q', { clear = true }),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable wrap and spell for text files',
  group = vim.api.nvim_create_augroup('wrap-spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  desc = 'Auto create directory on save',
  group = vim.api.nvim_create_augroup('auto-create-dir', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = vim.api.nvim_create_augroup('last-location', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_location then
      return
    end
    vim.b[buf].last_location = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if file changed outside of Neovim',
  group = vim.api.nvim_create_augroup('checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  desc = 'Show cursorline in active window',
  group = vim.api.nvim_create_augroup('auto-cursorline-show', { clear = true }),
  callback = function()
    if vim.wo.cursorline ~= true and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  desc = 'Hide cursorline in inactive window',
  group = vim.api.nvim_create_augroup('auto-cursorline-hide', { clear = true }),
  callback = function()
    if vim.wo.cursorline ~= false then
      vim.wo.cursorline = false
    end
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Fix conceallevel for json files',
  group = vim.api.nvim_create_augroup('json-conceal', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
