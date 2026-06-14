local M = {}

M.mod = "SUPER"

-- Programs
M.terminal = "kitty"
M.browser = "brave-origin-nightly"
M.school_browser = "chromium"
M.gui_filemanager = "thunar"
M.tui_filemanager = "yazi"
M.lockscreen = "hyprlock"
M.notifpanel = "swaync-client -t"
M.colorpicker = "hyprpicker -a"
M.gui_ide = "code"
M.tui_ide = "nvim"
M.passmanager = "bitwarden-desktop"
M.taskmanager = "btop"

-- Scripts
M.launcher = "$DOTFILES/rofi/launcher/launcher.sh"
M.powermenu = "$DOTFILES/rofi/powermenu/powermenu.sh"
M.websearch = "$DOTFILES/rofi/websearch/websearch.sh"

M.screenshot = "$DOTFILES/scripts/screenshot.sh"
M.screenshotfull = "$DOTFILES/scripts/screenshot-full.sh"
M.ocr = "$DOTFILES/scripts/ocr.sh"
M.zen = "$DOTFILES/scripts/toggle-zen.sh"
M.mediactl = "$DOTFILES/scripts/mediactl.sh"
M.zoom = "$DOTFILES/scripts/zoom.sh"
M.record = "$DOTFILES/scripts/toggle-obs.sh"

return M
