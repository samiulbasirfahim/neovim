---@type ChadrcConfig 
 local M = {}
 vim.g.toggle_theme_icon = ""
 M.ui = {
    -- theme = '',
    transparency = true,
    statusline = {
        theme = "default", -- default/vscode/vscode_colored/minimal
        -- default/round/block/arrow separators work only for default statusline theme
        -- round and block will work for minimal theme only
        separator_style = "block",
        overriden_modules = nil,
  },
  nvdash = {
    load_on_startup = true,
  }
}
 M.plugins = 'custom.plugins'
 return M
