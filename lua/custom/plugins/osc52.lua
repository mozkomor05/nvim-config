return {
	'ojroques/nvim-osc52',
	config = function()
		require('osc52').setup({
			max_length = 0,
			silent = false,
			trim = false,
		})

		vim.keymap.set("n", "<leader>c", require("osc52").copy_operator, { expr = true })
		vim.keymap.set("n", "<leader>cc", "<leader>c_", { remap = true })
		vim.keymap.set("x", "<leader>c", require("osc52").copy_visual)

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
