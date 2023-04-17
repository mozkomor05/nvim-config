return {
	'ojroques/nvim-osc52',
	config = function()
		require('osc52').setup({
			max_length = 0,
			silent = false,
			trim = false,
		})

		vim.api.nvim_create_autocmd('TextYankPost', {
			callback = function()
				if vim.v.event.operator == 'y' and vim.env.SSH_CONNECTION then
					require('osc52').copy_register('+')
				end
			end,
			pattern = '*',
		})
	end
}
