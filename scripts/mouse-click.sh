#!/bin/bash
set -euo pipefail

STATE_FILE="/tmp/mouse_state"
ydotool click 0x80 2>/dev/null || true
echo "released" >"$STATE_FILE"

case "$1" in
left) ydotool click 0x40 0x80 ;;
right) ydotool click 0x41 0x81 ;;
middle) ydotool click 0x42 0x82 ;;
toggle)
  CURRENT_STATE=$(cat "$STATE_FILE")

  if [ "$CURRENT_STATE" = "released" ]; then
    echo "pressed" >"$STATE_FILE"
    ydotool click 0x40
  else
    echo "released" >"$STATE_FILE"
    ydotool click 0x80
  fi
  ;;
esac
