local M = {}

local function get_tab_id()
  return "tab_term_" .. tostring(vim.api.nvim_get_current_tabpage())
end

M.toggle_tab_terminal = function(opts)
  local default_opts = {
    pos = "float",
    size = 0.5,
    direction = "horizontal",
  }
  local config = vim.tbl_extend("force", default_opts, opts or {})
  config.id = get_tab_id()
  require("nvchad.term").toggle(config)
end

return M
