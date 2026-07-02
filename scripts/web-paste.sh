#!/bin/bash
set -euo pipefail

BROWSER="$1"
URL="$2"
PROMPT="$3"

CLIP=$(wl-paste | tr '\n' ' ')
[ -z "$CLIP" ] && notify-send "Web Paste" "Clipboard is empty" && exit 1

"$BROWSER" --app="$URL" &
sleep 0.2

# Wait for active window title to stabilize by polling until the current title
# differs from the initial title, or up to ~4 seconds (40 iterations, 100ms apart).
# Exits loop when title changes or timeout expires.
for i in $(seq 1 40); do
  WIN_JSON=$(hyprctl activewindow -j 2>/dev/null || echo '{"title":"","initialTitle":""}')
  INIT_TITLE=$(echo "$WIN_JSON" | jq -r '.initialTitle // ""')
  CUR_TITLE=$(echo "$WIN_JSON" | jq -r '.title // ""')
  [ -n "$CUR_TITLE" ] && [ "$CUR_TITLE" != "$INIT_TITLE" ] && break
  sleep 0.1
done

sleep 0.5
ydotool type "$PROMPT"
ydotool key 42:1 28:1 28:0 42:0 # Shift+Enter → newline
ydotool key 29:1 47:1 47:0 29:0 # Ctrl+V
ydotool key 28:1 28:0           # Enter
