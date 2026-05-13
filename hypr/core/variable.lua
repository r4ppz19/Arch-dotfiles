local vars = {}

vars.mainMod = "SUPER"

-- Programs
vars.terminal = "kitty"
vars.browser = "brave"
vars.browserForSchool = "chromium"
vars.filemanager = "thunar"
vars.lockscreen = "hyprlock"
vars.notifpanel = "swaync-client -t"
vars.colorpicker = "hyprpicker -a"
vars.ide = "code"
vars.passmanager = "bitwarden-desktop"

-- Scripts
vars.launcher = "$DOTFILES/rofi/launcher/launcher.sh"
vars.powermenu = "$DOTFILES/rofi/powermenu/powermenu.sh"
vars.websearch = "$DOTFILES/rofi/websearch/websearch.sh"

vars.screenshot = "$DOTFILES/scripts/screenshot.sh"
vars.screenshotfull = "$DOTFILES/scripts/screenshot-full.sh"
vars.ocr = "$DOTFILES/scripts/ocr.sh"
vars.zen = "$DOTFILES/scripts/toggle-zen.sh"
vars.mediactl = "$DOTFILES/scripts/mediactl.sh"
vars.mouseclick = "$DOTFILES/scripts/mouse-click.sh"
vars.eyetemp = "$DOTFILES/scripts/toggle-hyprsunset.sh"
vars.zoom = "$DOTFILES/scripts/zoom.sh"
vars.record = "$DOTFILES/scripts/toggle-obs.sh"

return vars
