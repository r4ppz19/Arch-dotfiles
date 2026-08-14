#!/bin/bash
set -euo pipefail

# Download YouTube audio (music) in the highest quality.
# Prefer native Opus streams (no conversion).
# Fallback to the best available audio (e.g., AAC),
# then convert to a opus format (for consistency).

#
# You can alias it for shorter name like
# alias ytdl'=scriptPath'
#
# See: zsh/alias.zsh

OUTPUT_TEMPLATE='%(artist,uploader)s - %(title)s.opus'

if (($# < 1)); then
  echo "Usage: $0 URL [URL...]"
  exit 2
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp not found" >&2
  exit 1
fi

for url in "$@"; do
  # Determine what the final file name will be
  filename=$(yt-dlp --print filename -o "${OUTPUT_TEMPLATE}" "$url" 2>/dev/null || true)

  # Check if file exists and prompt user
  if [[ -n "$filename" && -f "$filename" ]]; then
    echo "Already downloaded: $filename"
    read -r -p "File already exists. Override? [y/N] " response
    # Default to 'n' if empty or anything other than y/Y
    case "$response" in
    [yY][eS][eS] | [yY])
      echo "Overriding..."
      ;;
    *)
      echo "Skipping."
      continue
      ;;
    esac
  fi

  yt-dlp \
    -f "bestaudio[acodec=opus]/bestaudio" \
    -o "${OUTPUT_TEMPLATE}" \
    -x --audio-format opus \
    --embed-metadata \
    --embed-thumbnail \
    --convert-thumbnails png \
    --ppa "thumbnailsconvertor:-vf crop='ih:ih'" \
    --no-part \
    --force-overwrites \
    --no-cache-dir \
    "$url"
done
