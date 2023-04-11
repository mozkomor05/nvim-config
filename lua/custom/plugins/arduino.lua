return {
	'stevearc/vim-arduino',
	config = function ()
		local nmap = function(keys, func, desc)
			if desc then
				desc = 'Arduino: ' .. desc
			end

			vim.keymap.set('n', keys, func, { desc = desc })
		end

		nmap('<leader>ar', '<cmd>ArduinoUpload<cr>', 'Upload')
		nmap('<leader>as', '<cmd>ArduinoSerial<cr>', 'Serial')
	end
}
