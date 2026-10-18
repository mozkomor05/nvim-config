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
        require('conform').format { async = true }
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
    -- Conform already skips formatters whose binary is missing and falls back to
    -- the LSP; this also silences the "Formatters unavailable for <ft>" warning
    -- on machines where a given tool simply isn't installed.
    notify_no_formatters = false,
    -- Applies to both <leader>f and format-on-save: prefer an external formatter
    -- from formatters_by_ft, fall back to the LSP when none is configured.
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true, prolog = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        -- 500ms is tight for a cold prettier/node start on a slower machine
        return { timeout_ms = 1500 }
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
      -- prolog: lsp_server's LSP formatting path formats the file on DISK and
      -- corrupts modified buffers (jamesnvc/lsp_server#40); the CLI on a temp
      -- copy of the buffer is safe
      prolog = { 'swipl_format' },
    },
    formatters = {
      swipl_format = {
        command = 'swipl',
        args = { 'formatter', '$FILENAME' },
        stdin = false,
      },
    },
  },
}
