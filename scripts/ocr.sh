#!/bin/bash
set -euo pipefail

LOCKFILE="/tmp/screenshot_ocr.lock"
TMPIMG="$(mktemp --suffix=.png)"
PROCESSED="$(mktemp --suffix=.png)"

cleanup() {
  rm -f "$LOCKFILE" "$TMPIMG" "$PROCESSED"
}
trap cleanup EXIT INT TERM

exec 200>"$LOCKFILE"
flock -n 200 || {
  notify-send -h boolean:transient:true \
    "OCR Already Running" \
    "Please wait for the current process to finish." \
    -i dialog-warning \
    -t 1400
  exit 1
}

# Check dependencies
for cmd in grim magick slurp tesseract wl-copy notify-send bc; do
  if ! command -v "$cmd" &>/dev/null; then
    printf "Missing required command: %s\n" "$cmd" >&2
    exit 1
  fi
done

# Prompt user for region
REGION="$(slurp)"
if [[ -z "$REGION" ]]; then
  notify-send -h boolean:transient:true \
    "OCR failed" \
    "No region selected.." \
    -i dialog-warning \
    -t 1400
  exit 1
fi

# Ensure slurp overlay clears before grim captures
sleep 0.2

grim -g "$REGION" "$TMPIMG"

BRIGHTNESS=$(magick "$TMPIMG" -colorspace Gray -format "%[fx:mean]" info:)
if (($(echo "$BRIGHTNESS < 0.5" | bc -l) == 1)); then
  PRE_OP="-negate"
else
  PRE_OP=""
fi
magick "$TMPIMG" \
  -colorspace Gray \
  $PRE_OP \
  -units PixelsPerInch -density 300 \
  -resize 400% \
  -level 10%,90% \
  -sharpen 0x1 \
  -negate \
  -lat 20x20+5% \
  -negate \
  "$PROCESSED"

TEXT="$(tesseract "$PROCESSED" - -l eng --psm 6 --oem 1)" || {
  notify-send -h boolean:transient:true \
    "OCR failed" \
    "Tesseract could not extract text." \
    -i dialog-error \
    -t 2000
  exit 1
}

if [[ -z "$TEXT" ]]; then
  notify-send -h boolean:transient:true \
    "OCR failed" \
    "No text detected in the image." \
    -i dialog-error \
    -t 2000
  exit 1
fi

printf '%s' "$TEXT" | wl-copy

notify-send -h boolean:transient:true \
  "OCR copied to clipboard" \
  "Text has been successfully copied." \
  -i dialog-warning \
  -t 1400
