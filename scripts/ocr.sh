#!/bin/bash

# Dependencies: slurp grim tesseract wl-clipboard tesseract-data-eng

LOCKFILE="/tmp/screenshot_ocr.lock"
TMPIMG=$(mktemp --suffix=.png)

# Check if lockfile exists and if the process is still running
if [ -f "$LOCKFILE" ]; then
  PID=$(cat "$LOCKFILE")
  if kill -0 "$PID" 2>/dev/null; then
    echo "Script already running with PID $PID. Exiting."
    exit 1
  else
    # Stale lockfile found, remove it
    rm "$LOCKFILE"
  fi
fi

# Create lockfile with current PID
echo $$ >"$LOCKFILE"

# Cleanup function to remove lockfile and temp image on exit or interrupt
cleanup() {
  rm -f "$LOCKFILE" "$TMPIMG"
}
trap cleanup EXIT INT TERM

# Step 1: Select a region and take screenshot
slurp | grim -g - "$TMPIMG"

# Step 2: OCR with tesseract and copy to clipboard
tesseract "$TMPIMG" - -l eng | wl-copy
