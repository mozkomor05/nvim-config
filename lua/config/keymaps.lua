-- Keymaps Configuration
-- This file contains all core keybindings
-- Plugin-specific keymaps are defined in their respective plugin files

local map = vim.keymap.set

-- Clear search highlights
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Move visual selection
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Paste without replacing current register
map('x', '<leader>p', '"_dP', { desc = 'Paste without replacing register' })

-- Better window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to upper window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })

-- Terminal mode escape
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Quality of Life improvements
-- Better indenting
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Better page navigation - keep cursor centered
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Better line joining
map('n', 'J', 'mzJ`z', { desc = 'Join lines and restore cursor' })

-- Save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Better quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = '[Q]uit all' })

-- Window management
map('n', '<leader>ww', '<C-W>p', { desc = 'Other [W]indow' })
map('n', '<leader>wd', '<C-W>c', { desc = '[D]elete [W]indow' })
map('n', '<leader>w-', '<C-W>s', { desc = 'Split [W]indow below' })
map('n', '<leader>w|', '<C-W>v', { desc = 'Split [W]indow right' })

-- Tab management
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Buffer management
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[D]elete [B]uffer' })

-- Better command mode navigation
map('c', '<C-a>', '<Home>', { desc = 'Go to beginning of line' })

-- Toggle options
local toggle = function(option)
  return function()
    vim.wo[option] = not vim.wo[option]
    vim.notify(option .. ' = ' .. tostring(vim.wo[option]))
  end
end

map('n', '<leader>tw', toggle 'wrap', { desc = '[T]oggle [W]rap' })
map('n', '<leader>ts', toggle 'spell', { desc = '[T]oggle [S]pelling' })
map('n', '<leader>tn', toggle 'relativenumber', { desc = '[T]oggle [R]elative Number' })
map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify('Diagnostics ' .. (vim.diagnostic.is_enabled() and 'enabled' or 'disabled'))
end, { desc = '[T]oggle [D]iagnostics' })
