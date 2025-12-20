#!/bin/bash
set -euo pipefail

LOCKFILE="/tmp/screenshot.lock"
SCREENSHOT_DIR="$HOME/Pictures/screenshot"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
FILENAME="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

exec 200>"$LOCKFILE"
flock -n 200 || {
  notify-send -h boolean:transient:true \
    "Screenshot Already Running" \
    "Please wait for the current process to finish." \
    -i dialog-warning \
    -t 1400
  exit 1
}

for cmd in grim notify-send; do
  if ! command -v "$cmd" &>/dev/null; then
    printf "Missing required command: %s\n" "$cmd" >&2
    exit 1
  fi
done

mkdir -p "$SCREENSHOT_DIR"

grim "$FILENAME"

if [[ -s "$FILENAME" ]]; then
  notify-send -h boolean:transient:true \
    "Screenshot Taken" \
    "Full screen saved to: $FILENAME" \
    -i camera \
    -t 1400
  exit 0
else
  notify-send -h boolean:transient:true \
    "Screenshot Failed" \
    "Could not save the screenshot." \
    -i dialog-error \
    -t 1400
  exit 1
fi
