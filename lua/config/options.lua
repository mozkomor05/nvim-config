-- Neovim Options Configuration
-- This file contains all vim settings and options

-- Leader keys - must be set before lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- Line Numbers
vim.o.number = true
vim.o.relativenumber = true

-- Mouse Support
vim.o.mouse = 'a'

-- Mode Display
vim.o.showmode = false

-- Colors
vim.o.termguicolors = true

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Indentation
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Undo History
vim.o.undofile = true
local undodir = os.getenv 'HOME' .. '/.undodir'
vim.fn.mkdir(undodir, 'p')
vim.o.undodir = undodir
vim.o.undolevels = 10000

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.inccommand = 'split' -- Preview substitutions live

-- Sign Column
vim.o.signcolumn = 'yes'

-- Update Time & Timeouts
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Whitespace Display
vim.o.list = true
vim.o.listchars = 'tab:» ,trail:·,nbsp:␣'

-- Cursor Line
vim.o.cursorline = true

-- Scrolloff
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8

-- Completion
vim.o.completeopt = 'menu,menuone,noinsert,noselect'
vim.o.pumheight = 10 -- Max items in completion menu

-- Better search experience
vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'

-- Quality of Life improvements
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.wrap = false -- Disable line wrap by default
vim.o.linebreak = true -- Wrap on word boundary
vim.o.smoothscroll = true -- Smooth scrolling on wrap

-- Persistent undo across sessions
vim.o.swapfile = false
vim.o.backup = false

-- Better completion experience
vim.o.shortmess = vim.o.shortmess .. 'c' -- Don't show completion messages

-- Performance
vim.o.lazyredraw = false -- True to not redraw while executing macros (performance), False for better UX

-- File encoding
vim.o.fileencoding = 'utf-8'

-- Better formatting
vim.o.formatoptions = 'jcroqlnt' -- tcqj
