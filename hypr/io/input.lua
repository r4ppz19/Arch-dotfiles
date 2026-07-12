hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    float_switch_override_focus = 0,
    follow_mouse = 2,
    mouse_refocus = true,
    numlock_by_default = false,
    sensitivity = -0.6,

    repeat_delay = 255,
    repeat_rate = 60,

    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
      scroll_factor = 0.1,
      tap_to_click = false,
    },
  },

  cursor = {
    no_warps = true,
    inactive_timeout = 10,
    no_hardware_cursors = true,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
