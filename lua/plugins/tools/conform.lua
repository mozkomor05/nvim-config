-- Conform - Autoformatting
-- Modern formatter with support for multiple formatters per filetype

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>tf',
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Format on save ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
      end,
      desc = '[T]oggle [F]ormat on save',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true, prolog = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      cpp = { 'clang-format' },
      c = { 'clang-format' },
      go = { 'goimports', 'gofmt' },
      rust = { 'rustfmt' },
      json = { 'jq' },
      yaml = { 'yamlfmt' },
      markdown = { 'prettier' },
      -- haskell: formatting handled by HLS (ormolu via LSP); no external binary
    },
  },
}
