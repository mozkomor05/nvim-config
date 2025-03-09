return {
  'stevearc/vim-arduino',
  config = function()
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'Arduino: ' .. desc
      end

      vim.keymap.set('n', keys, func, { desc = desc })
    end

    nmap('<leader>aa', '<cmd>ArduinoAttach<cr>', 'Attach')
    nmap('<leader>av', '<cmd>ArduinoVerify<cr>', 'Verify')
    nmap('<leader>au', '<cmd>ArduinoUpload<cr>', 'Upload')
    nmap('<leader>aus', '<cmd>ArduinoUploadAndSerial<cr>', 'Upload and Serial')
    nmap('<leader>as', '<cmd>ArduinoSerial<cr>', 'Serial')
    nmap('<leader>ab', '<cmd>ArduinoChooseBoard<cr>', 'Choose Board')
    nmap('<leader>ap', '<cmd>ArduinoChooseProgrammer<cr>', 'Choose Programmer')
  end,
}
