local M = {}

M.toggle_tab_terminal = function(opts)
  local default_opts = {
    pos = "float",
    size = 0.5,
    direction = "horizontal",
  }
  local config = vim.tbl_extend("force", default_opts, opts or {})
  config.id = "tab_term_" .. tostring(vim.api.nvim_get_current_tabpage()) .. "_" .. config.pos
  require("nvchad.term").toggle(config)
end

return M
