-- LSP Configuration
-- Language Server Protocol setup with mason, lspconfig, and additional tools

return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools
      { 'mason-org/mason.nvim', opts = {} },
      -- Translates lspconfig server names <-> mason package names.
      -- automatic_enable = false because we call vim.lsp.enable() ourselves below;
      -- leaving it on would enable every installed server a second time.
      { 'mason-org/mason-lspconfig.nvim', opts = { automatic_enable = false } },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

    },
    config = function()
      local machine = require 'config.machine'

      -- LSP Attach Handler
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Document highlight on cursor hold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints toggle
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Configuration
      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
        virtual_lines = false, -- switch to true for multi-line diagnostics
        -- Auto-open float when jumping to a diagnostic with [d / ]d
        jump = {
          on_jump = function(_, bufnr)
            vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
          end,
        },
      }

      -- blink.cmp registers its capabilities with core LSP automatically;
      -- no manual capabilities merging needed.

      -- LSP Servers Configuration
      local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        arduino_language_server = {},
        ts_ls = {},
        intelephense = {},
        lua_ls = {
          on_init = function(client)
            -- Let stylua handle formatting; disable lua_ls's own formatter
            client.server_capabilities.documentFormattingProvider = false
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config'
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
              runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
            })
          end,
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              format = { enable = false },
            },
          },
        },
      }

      -- Mason installs only what THIS machine opted into (see lua/config/machine.lua).
      -- Defaults to nothing: a fresh clone on a new machine downloads no servers.
      -- Add them per-machine in machine-local.lua, or install by hand with `:Mason`.
      require('mason-tool-installer').setup { ensure_installed = machine.opts.mason_ensure }

      -- Servers usually installed via system packages rather than Mason
      if machine.have 'haskell-language-server-wrapper' then
        servers.hls = { filetypes = { 'haskell', 'lhaskell', 'cabal' } }
      end
      if machine.have 'swipl' then
        servers.prolog_ls = {
          cmd = { 'swipl', '-g', 'use_module(library(lsp_server)).', '-g', 'lsp_server:main', '-t', 'halt', '--', 'stdio' },
          filetypes = { 'prolog' },
          root_markers = { '.git' },
          on_init = function(client)
            -- lsp_server's formatter corrupts files with non-ASCII text; diagnostics only
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {},
        }
      end

      -- Some servers resolve `cmd` through a function, so it can't be probed
      -- generically; name their executable explicitly here.
      local server_bin = {
        ts_ls = 'typescript-language-server',
      }

      --- Is this server's executable actually present on this machine?
      ---@param name string
      ---@return boolean
      local function server_available(name)
        local bin = server_bin[name]
        if bin then
          return machine.have(bin)
        end
        -- vim.lsp.config[name] is the spec merged with nvim-lspconfig's defaults
        local cmd = (vim.lsp.config[name] or {}).cmd
        if type(cmd) == 'table' and cmd[1] then
          return machine.have(cmd[1])
        end
        -- Dynamic or unknown cmd: let Neovim decide at start time
        return true
      end

      -- Register every server we know how to configure, but only enable the ones
      -- whose binary exists. Enabling a missing server makes Neovim error out
      -- ("command is not executable") every time you open a matching file.
      local enabled, missing = {}, {}
      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        if server_available(name) then
          vim.lsp.enable(name)
          table.insert(enabled, name)
        else
          table.insert(missing, name)
        end
      end
      table.sort(enabled)
      table.sort(missing)
      -- Consumed by :ToolsMissing (see lua/config/autocmds.lua)
      vim.g.lsp_enabled = enabled
      vim.g.lsp_missing = missing
    end,
  },

  -- Lua LSP configuration for Neovim API
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
