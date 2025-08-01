#!/bin/bash
set -euo pipefail

LOCKFILE="/tmp/screenshot_ocr.lock"
TMPIMG="$(mktemp --suffix=.png)"

cleanup() {
  rm -f "$LOCKFILE" "$TMPIMG"
}
trap cleanup EXIT INT TERM

# Check for existing lock
if [[ -f "$LOCKFILE" ]]; then
  PID=$(<"$LOCKFILE")
  if kill -0 "$PID" 2>/dev/null; then
    echo "Script already running with PID $PID. Exiting."
    exit 1
  else
    rm -f "$LOCKFILE"
  fi
fi

echo "$$" >"$LOCKFILE"

# Ensure dependencies are installed
for cmd in grim slurp tesseract wl-copy; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is not installed." >&2
    exit 1
  fi
done

# Capture region and run OCR
if REGION="$(slurp)"; then
  grim -g "$REGION" "$TMPIMG"
  tesseract "$TMPIMG" - -l eng | wl-copy
else
  echo "Selection cancelled."
  exit 1
fi

