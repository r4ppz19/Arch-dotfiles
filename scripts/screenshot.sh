#!/bin/bash
set -euo pipefail

LOCKFILE="/tmp/screenshot.lock"
SCREENSHOT_DIR="$HOME/Pictures/screenshot"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
FILENAME="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

# Lock to prevent concurrent screenshots
exec 200>"$LOCKFILE"
flock -n 200 || {
  notify-send -h boolean:transient:true \
    "Screenshot Already Running" \
    "Please wait for the current process to finish." \
    -i dialog-warning
  exit 1
}

# Ensure dependencies are available
for cmd in grim slurp; do
  if ! command -v "$cmd" &>/dev/null; then
    notify-send -h boolean:transient:true \
      "Screenshot Failed" \
      "Missing dependency: $cmd" \
      -i dialog-error
    exit 1
  fi
done

mkdir -p "$SCREENSHOT_DIR"

# Prompt user for region
REGION="$(slurp)"
if [[ -z "$REGION" ]]; then
  notify-send -h boolean:transient:true \
    "Screenshot Canceled" \
    "No region selected." \
    -i dialog-warning
  exit 1
fi

# Ensure slurp overlay clears before grim captures
sleep 0.2

# Take the screenshot
grim -g "$REGION" "$FILENAME"

# Validate result
if [[ -s "$FILENAME" ]]; then
  notify-send -h boolean:transient:true \
    "Screenshot Taken" \
    "Saved to: $FILENAME\nRegion: $REGION" \
    -i camera
  exit 0
else
  notify-send -h boolean:transient:true \
    "Screenshot Failed" \
    "Could not save the screenshot." \
    -i dialog-error
  exit 1
fi

