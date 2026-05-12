hl.env("GDK_SCALE", "1")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("QT_QPA_PLATFORMTHEME", "kvantum")

hl.env("DOTFILES", os.getenv("HOME") .. "/Arch-dotfiles")
