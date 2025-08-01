#!/bin/bash
set -euo pipefail

STATE_FILE="$HOME/.cache/hyprsunset_mode"

[[ ! -f "$STATE_FILE" ]] && echo "day" > "$STATE_FILE"
read -r MODE < "$STATE_FILE"

case "$MODE" in
  day)
    echo "Switching to NIGHT mode..."
    hyprctl hyprsunset temperature 3800
    hyprctl hyprsunset gamma 90
    echo "night" > "$STATE_FILE"
    ;;
  night)
    echo "Switching to DAY mode..."
    hyprctl hyprsunset temperature 5000
    hyprctl hyprsunset gamma 95
    echo "day" > "$STATE_FILE"
    ;;
  *)
    echo "Unknown mode: '$MODE'. Resetting to 'day'."
    echo "day" > "$STATE_FILE"
    ;;
esac

