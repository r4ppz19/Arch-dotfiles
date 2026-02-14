local excluded = { "NvimTree", "copilot-chat", "neo-tree", "Outline" }

-- Helper: Find a valid "main" window
local function focus_main_window()
  local current_buf = vim.api.nvim_get_current_buf()
  local is_sidebar = vim.tbl_contains(excluded, vim.bo[current_buf].filetype)
  local is_term = vim.bo[current_buf].buftype == "terminal"

  -- Only redirect focus if we are in a restricted area
  if is_sidebar or is_term then
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, w in ipairs(wins) do
      local b = vim.api.nvim_win_get_buf(w)
      local ft = vim.bo[b].filetype
      local bt = vim.bo[b].buftype

      -- Check if this window is a valid "code" window
      if not vim.tbl_contains(excluded, ft) and bt ~= "terminal" and bt ~= "nofile" then
        vim.api.nvim_set_current_win(w)
        return
      end
    end
  end
end

return focus_main_window
