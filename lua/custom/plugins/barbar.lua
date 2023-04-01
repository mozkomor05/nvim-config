vim.api.nvim_create_autocmd('FileType', {
	callback = function(tbl)
		local set_offset = require('barbar.api').set_offset

		local bufwinid
		local last_width
		local autocmd = vim.api.nvim_create_autocmd('WinScrolled', {
			callback = function()
				bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)

				local width = vim.api.nvim_win_get_width(bufwinid)
				if width ~= last_width then
					set_offset(width, 'File Tree')
					last_width = width
				end
			end,
		})

		vim.api.nvim_create_autocmd('BufWipeout', {
			buffer = tbl.buf,
			callback = function()
				vim.api.nvim_del_autocmd(autocmd)
				set_offset(0)
			end,
			once = true,
		})
	end,
	pattern = 'NvimTree', -- or any other filetree's `ft`
})

return {
	'romgrk/barbar.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons',
	cond = not vim.g.started_by_firenvim,
	config = function()
		require('barbar').setup({
			icons = {
				-- Enables / disables diagnostic symbols
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
					[vim.diagnostic.severity.WARN] = { enabled = false },
					[vim.diagnostic.severity.INFO] = { enabled = false },
					[vim.diagnostic.severity.HINT] = { enabled = true },
				},
				-- Configure the icons on the bufferline when modified or pinned.
				-- Supports all the base icon options.
				modified = { button = '●' },
				pinned = { button = '車' },
			},
		})

		vim.keymap.set('n', '<A-j>', vim.cmd.BufferPrevious)
		vim.keymap.set('n', '<A-k>', vim.cmd.BufferNext)
		vim.keymap.set('n', '<A-,>', vim.cmd.BufferMovePrevious)
		vim.keymap.set('n', '<A-.>', vim.cmd.BufferMoveNext)
		vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
		vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
		vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
		vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
		vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
		vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
		vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
		vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
		vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
		vim.keymap.set('n', '<A-0>', vim.cmd.BufferLast)
		vim.keymap.set('n', '<A-p>', vim.cmd.BufferPin)
		vim.keymap.set('n', '<A-o>', vim.cmd.BufferPick)
		vim.keymap.set('n', '<A-q>', vim.cmd.BufferClose)
	end
}
