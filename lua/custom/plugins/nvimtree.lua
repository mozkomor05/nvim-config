local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then
		return
	end

	-- switch to directory
	vim.cmd.cd(data.file)

	-- open the tree
	require('nvim-tree.api').tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

return {
	'nvim-tree/nvim-tree.lua',
	denendencies = {
		'nvim-tree/nvim-web-devicons'
	},
	cond = not vim.g.started_by_firenvim,
	keys = {
		{ '<leader>nf', vim.cmd.NvimTreeFocus,												desc = '[N]vimTree [F]ocus' },
		{ '<leader>no', vim.cmd.NvimTreeFindFile,											desc = '[N]vimTree [O]pen current file' },
		{ '<leader>nt', function() require('nvim-tree.api').tree.toggle(false, true) end,	desc = '[N]vimTree [T]oggle' },
	},
	config = function()
		local lib = require('nvim-tree.lib')
		local api = require('nvim-tree.api')

		local git_add = function()
			local node = lib.get_node_at_cursor()

			if not node then
				return
			end

			local gs = node.git_status.file

			-- If the file is untracked, unstaged or partially staged, we stage it
			if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
				vim.cmd("silent !git add " .. node.absolute_path)

				-- If the file is staged, we unstage
			elseif gs == "M " or gs == "A " then
				vim.cmd("silent !git restore --staged " .. node.absolute_path)
			end

			lib.refresh_tree()
		end
		local on_attach = function(bufnr)
			api.config.mappings.default_on_attach(bufnr)

			local function opts(desc)
				return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			vim.keymap.set('n', 'ga', git_add, opts('Git Add'))
		end

		require('nvim-tree').setup({
			on_attach = on_attach,
			disable_netrw = false,
			hijack_netrw = true,
		})
	end
}
