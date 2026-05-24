hl.env("GDK_SCALE", "1")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("QT_QPA_PLATFORMTHEME", "kvantum")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XCURSOR_THEME", "Hackneyed-24px")
hl.env("XCURSOR_SIZE", "24")

hl.env("DOTFILES", os.getenv("HOME") .. "/Arch-dotfiles")
