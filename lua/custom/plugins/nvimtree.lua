local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not no_name and not directory then
		return
	end

	if directory then
		vim.cmd.cd(data.file)
	end

	-- open the tree, find the file but don't focus it
	require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

return {
	'nvim-tree/nvim-tree.lua',
	denendencies = {
		'nvim-tree/nvim-web-devicons'
	},
	cond = not vim.g.started_by_firenvim,
	keys = {
		{ '<leader>nf', vim.cmd.NvimTreeFocus,                                            desc = '[N]vimTree [F]ocus' },
		{ '<leader>no', vim.cmd.NvimTreeFindFile,                                         desc = '[N]vimTree [O]pen current file' },
		{ '<leader>nt', function() require('nvim-tree.api').tree.toggle(false, true) end, desc = '[N]vimTree [T]oggle' },
	},
	config = function()
		local lib = require("nvim-tree.lib")
		local api = require('nvim-tree.api')

		local git_add = function()
			local node = lib.get_node_at_cursor()
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

			vim.keymap.set('n', 'ga', git_add, { buffer = bufnr })
		end


		require('nvim-tree').setup({
			on_attach = on_attach,
		})

		local function tab_win_closed(winnr)
			local tabnr = vim.api.nvim_win_get_tabpage(winnr)
			local bufnr = vim.api.nvim_win_get_buf(winnr)
			local buf_info = vim.fn.getbufinfo(bufnr)[1]
			local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
			local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
			if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
				-- Close all nvim tree on :q
				if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
				api.tree.close()
				end
			else                                         -- else closed buffer was normal buffer
				if #tab_bufs == 1 then                   -- if there is only 1 buffer left in the tab
					local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
					if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
						vim.schedule(function()
							if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
								vim.cmd.quit()
							else                         -- else there are more tabs open
								vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
							end
						end)
					end
				end
			end
		end

		vim.api.nvim_create_autocmd('WinClosed', {
			callback = function()
				local winnr = tonumber(vim.fn.expand("<amatch>"))
				vim.schedule_wrap(tab_win_closed(winnr))
			end,
			nested = true
		})
	end
}
