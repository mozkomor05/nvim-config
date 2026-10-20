-- Catppuccin Theme
-- Beautiful pastel theme

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  opts = {
    flavour = 'mocha',
    term_colors = true,
    transparent_background = false,
    dim_inactive = {
      enabled = false,
      shade = 'dark',
      percentage = 0.15,
    },
    -- Diagnostic styling now lives in the top-level `lsp_styles` table (the old
    -- `integrations.native_lsp` block was removed upstream); its defaults are
    -- italic virtual text + underlines, which is what this config used.
    --
    -- auto_integrations is off: on Neovim 0.12 it calls vim.pack.get(), which
    -- creates an empty site/pack/core on every start (and makes :checkhealth
    -- warn about it). The list below is exactly what auto-detection found;
    -- add an entry here when you install a plugin catppuccin supports.
    auto_integrations = false,
    integrations = {
      blink_cmp = { enabled = true, style = 'bordered' },
      dap = true,
      dap_ui = true,
      fidget = true,
      gitsigns = true,
      indent_blankline = { enabled = true, colored_indent_levels = false },
      mason = true,
      mini = { enabled = true },
      nvimtree = true,
      telescope = { enabled = true },
      treesitter = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
