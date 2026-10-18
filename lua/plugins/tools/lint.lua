-- Linting Configuration
-- nvim-lint for asynchronous linting

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local machine = require 'config.machine'

    local wanted = {
      markdown = { 'markdownlint' },
      python = { 'pylint' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      haskell = { 'hlint' },
    }

    --- Both the linter spec and its `cmd` may be functions (e.g. eslint_d), so
    --- resolve both before probing. A cmd that stays unresolvable is assumed
    --- present and left for nvim-lint to deal with.
    local function available(name)
      local got, linter = pcall(function()
        return lint.linters[name]
      end)
      if got and type(linter) == 'function' then
        got, linter = pcall(linter)
      end
      if not got or type(linter) ~= 'table' then
        return false
      end
      local cmd = linter.cmd
      if type(cmd) == 'function' then
        local resolved
        got, resolved = pcall(cmd)
        cmd = got and resolved or nil
      end
      return type(cmd) ~= 'string' or machine.have(cmd)
    end

    -- nvim-lint notifies "Error running <cmd>: ENOENT" on every trigger for a
    -- linter whose binary is absent, so register only the ones this machine has.
    -- After installing one, `:Lazy reload nvim-lint` picks it up.
    local enabled, missing = {}, {}
    lint.linters_by_ft = vim.tbl_map(function(names)
      return vim.tbl_filter(function(name)
        local ok = available(name)
        local bucket = ok and enabled or missing
        if not vim.tbl_contains(bucket, name) then
          table.insert(bucket, name)
        end
        return ok
      end, names)
    end, wanted)
    -- Consumed by :ToolsMissing
    vim.g.lint_enabled, vim.g.lint_missing = enabled, missing

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      desc = 'Lint the current buffer',
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      callback = function()
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })

    vim.keymap.set('n', '<leader>cl', function()
      lint.try_lint()
    end, { desc = '[C]ode [L]int' })
  end,
}
