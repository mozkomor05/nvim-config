-- Treesitter (main branch API) — auto-installs parsers on FileType
-- https://github.com/nvim-treesitter/nvim-treesitter (main branch)

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local parsers = {
      'bash', 'c', 'cpp', 'diff', 'haskell', 'html', 'javascript', 'json',
      'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query',
      'regex', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
    }
    require('nvim-treesitter').install(parsers)

    local function try_attach(buf, lang)
      -- The buffer may be gone by the time an async parser install finishes
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if not vim.treesitter.language.add(lang) then return end
      vim.treesitter.start(buf, lang)
      if vim.treesitter.query.get(lang, 'indents') ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local available = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
      callback = function(args)
        local buf, ft = args.buf, args.match
        -- VimTeX owns LaTeX syntax/indent; treesitter must not attach
        if ft == 'tex' or ft == 'latex' then return end
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then return end
        local installed = require('nvim-treesitter').get_installed('parsers')
        if vim.tbl_contains(installed, lang) then
          try_attach(buf, lang)
        elseif vim.tbl_contains(available, lang) then
          require('nvim-treesitter').install(lang):await(function() try_attach(buf, lang) end)
        else
          try_attach(buf, lang)
        end
      end,
    })

    -- NOTE: incremental selection is built into Neovim >= 0.12 -- in visual mode use
    -- `an`/`in` to grow/shrink by node and `]n`/`[n` to step between siblings.
    -- See `:help treesitter-incremental-selection`.
  end,
}
