local M = {}

function M.zoom_in()
  local current = hl.get_config("cursor.zoom_factor")
  if current < 1 then
    current = 1
  end
  hl.config({ cursor = { zoom_factor = current * 1.25 } })
end

function M.zoom_out()
  local current = hl.get_config("cursor.zoom_factor")
  if current < 1 then
    current = 1
  end
  local new_zoom = current / 1.25
  if new_zoom < 1 then
    new_zoom = 1.0
  end
  hl.config({ cursor = { zoom_factor = new_zoom } })
end

function M.zoom_reset()
  hl.config({ cursor = { zoom_factor = 1.0 } })
end

return M
