#!/usr/bin/env bash
set -euo pipefail

# Download YouTube audio (music) in the highest quality.
# Prefer native Opus streams (no conversion).
# Fallback to the best available audio (e.g., AAC),
# then convert to a single format.

OUTPUT_TEMPLATE='%(title)s.%(ext)s'

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 URL [URL...]"
  exit 2
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp not found" >&2
  exit 1
fi

yt-dlp \
  -f "bestaudio[acodec=opus]/bestaudio" \
  -o "${OUTPUT_TEMPLATE}" \
  -x --audio-format opus \
  --embed-metadata \
  --embed-thumbnail \
  --convert-thumbnails jpg \
  "$@"

# Cleanup
find . -name "*.webp" -delete
find . -name "*.info.json" -delete
