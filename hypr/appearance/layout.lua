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
    mfact = 0.60,
  },
})

hl.bind("ALT + TAB", hl.dsp.layout("rollnext"))
hl.bind("ALT + SHIFT + TAB ", hl.dsp.layout("rollprev"))
