local M = {}

M.mod = "SUPER"

-- Programs
M.terminal = "kitty"
M.browser = "brave"
M.school_browser = "chromium"
M.filemanager = "thunar"
M.lockscreen = "hyprlock"
M.notifpanel = "swaync-client -t"
M.colorpicker = "hyprpicker -a"
M.ide = "code"
M.passmanager = "bitwarden-desktop"

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
