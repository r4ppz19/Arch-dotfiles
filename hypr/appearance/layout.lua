local M = {}

hl.config({
  layout = {
    single_window_aspect_ratio = { 0, 0 },
    single_window_aspect_ratio_tolerance = 0.1,
  },

  general = {
    layout = "master",
  },

  dwindle = {
    preserve_split = true,
    force_split = 3,
    split_bias = 2,
  },

  master = {
    new_status = "slave",
    mfact = 0.66,
  },
})

hl.bind("ALT + TAB", function()
  if M.get_current_layout() == "master" then
    hl.dispatch(hl.dsp.layout("rollnext"))
  end
end)

hl.bind("ALT + SHIFT + TAB", function()
  if M.get_current_layout() == "master" then
    hl.dispatch(hl.dsp.layout("rollprev"))
  end
end)

function M.get_current_layout()
  return hl.get_active_workspace().tiled_layout
end

return M
