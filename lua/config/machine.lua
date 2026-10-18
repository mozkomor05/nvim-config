-- Per-machine capabilities and overrides (Linux and macOS only)
--
-- This config is cloned onto several machines that do not have the same tools
-- installed. Optional tooling -- formatters, linters, language servers -- is
-- probed at startup and quietly skipped when absent.
--
-- Tools the config genuinely cannot work without are listed in `M.critical` and
-- are NOT skipped quietly: they are reported once at startup.
--
-- To pin machine-specific choices, copy `machine-local.lua.example` to
-- `lua/config/machine-local.lua` (gitignored) and edit it.

local M = {}

M.is_mac = vim.uv.os_uname().sysname == 'Darwin'

--- Is `bin` runnable on this machine?
--- Mason prepends its own bin directory to $PATH, so this covers both
--- Mason-installed and system-installed (brew, pacman, cargo, ...) tools.
---@param bin string
---@return boolean
function M.have(bin)
  return vim.fn.executable(bin) == 1
end

-- Defaults, overridable by lua/config/machine-local.lua
local defaults = {
  -- Nerd Font glyphs in the UI. Set false on a machine whose terminal font
  -- has no patched glyphs.
  nerd_font = true,

  -- Mason packages to install automatically on THIS machine.
  -- Empty by default on purpose: a fresh clone installs nothing and downloads
  -- nothing. Servers and formatters already on the system are still detected
  -- and used. Populate per-machine, then `:MasonToolsInstall`.
  mason_ensure = {},

  -- VimTeX PDF viewer. nil means "probe for one".
  tex_viewer = nil,
}

local ok, overrides = pcall(require, 'config.machine-local')
M.opts = vim.tbl_deep_extend('force', defaults, (ok and type(overrides) == 'table') and overrides or {})

-- Without these the config is broken rather than merely reduced, so a missing
-- one is worth a warning. Each entry is a list of interchangeable binaries.
M.critical = {
  { bins = { 'git' }, why = 'lazy.nvim cannot install or update plugins' },
  { bins = { 'rg' }, why = 'telescope live_grep and grep_string return nothing' },
  { bins = { 'cc', 'gcc', 'clang' }, why = 'nvim-treesitter cannot build parsers' },
}

--- Critical tools that are absent, as human-readable lines.
---@return string[]
function M.missing_critical()
  local missing = {}
  for _, item in ipairs(M.critical) do
    local found = false
    for _, bin in ipairs(item.bins) do
      found = found or M.have(bin)
    end
    if not found then
      table.insert(missing, ('  %s -- %s'):format(table.concat(item.bins, ' / '), item.why))
    end
  end
  return missing
end

--- VimTeX viewer for this machine.
---@return string
function M.tex_viewer()
  if M.opts.tex_viewer then
    return M.opts.tex_viewer
  end
  -- Skim is the only viewer with working forward/inverse search on macOS.
  if M.is_mac then
    return M.have '/Applications/Skim.app/Contents/SharedSupport/displayline' and 'skim' or 'general'
  end
  for _, viewer in ipairs { 'zathura', 'sioyek', 'mupdf' } do
    if M.have(viewer) then
      return viewer
    end
  end
  return 'general'
end

-- Report configured-but-absent tooling. Optional tools are skipped silently at
-- runtime, so this is how you find out what a new machine is missing.
vim.api.nvim_create_user_command('ToolsMissing', function()
  -- conform and nvim-lint are lazy-loaded; without this the report is empty
  -- until a file has been opened.
  pcall(function()
    require('lazy').load { plugins = { 'conform.nvim', 'nvim-lint' } }
  end)

  local lines = {}
  local function section(title, present, absent)
    table.sort(present)
    table.sort(absent)
    table.insert(lines, title)
    table.insert(lines, '  present: ' .. (next(present) and table.concat(present, ', ') or '(none)'))
    table.insert(lines, '  missing: ' .. (next(absent) and table.concat(absent, ', ') or '(none)'))
  end

  section('LSP servers', vim.g.lsp_enabled or {}, vim.g.lsp_missing or {})

  local got, conform = pcall(require, 'conform')
  if got then
    local present, absent, seen = {}, {}, {}
    for _, names in pairs(conform.formatters_by_ft) do
      for _, name in ipairs(names) do
        if type(name) == 'string' and not seen[name] then
          seen[name] = true
          table.insert(conform.get_formatter_info(name).available and present or absent, name)
        end
      end
    end
    section('Formatters', present, absent)
  end

  section('Linters', vim.g.lint_enabled or {}, vim.g.lint_missing or {})

  local critical = M.missing_critical()
  table.insert(lines, 'Critical')
  table.insert(lines, next(critical) and table.concat(critical, '\n') or '  all present')

  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, { desc = 'Show which configured tools are missing on this machine' })

return M
