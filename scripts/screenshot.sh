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

for cmd in grim slurp notify-send; do
  if ! command -v "$cmd" &>/dev/null; then
    printf "Missing required command: %s\n" "$cmd" >&2
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
    -i dialog-warning \
    -t 1400
  exit 1
fi

# Ensure slurp overlay clears before grim captures
sleep 0.2

grim -g "$REGION" "$FILENAME"

if [[ -s "$FILENAME" ]]; then
  notify-send -h boolean:transient:true \
    "Screenshot Taken" \
    "Saved to: $FILENAME\nRegion: $REGION" \
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
