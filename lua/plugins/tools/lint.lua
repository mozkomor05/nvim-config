-- Linting Configuration
-- nvim-lint for asynchronous linting

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      python = { 'pylint' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
    }

    -- Create autocommand for linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run linter on modifiable buffers
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint trigger
    vim.keymap.set('n', '<leader>cl', function()
      lint.try_lint()
    end, { desc = '[C]ode [L]int' })
  end,
}
