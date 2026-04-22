#!/usr/bin/env bash
set -euo pipefail

# Download YouTube audio (music) in the highest quality.
# Prefer native Opus streams (no conversion).
# Fallback to the best available audio (e.g., AAC),
# then convert to a upos format (for consistency).
#
# You can alias it for shorter name like
# alias ytdl'=scriptPath'
#
# See: zsh/alias.zsh

OUTPUT_TEMPLATE='%(artist,uploader)s - %(title)s.%(ext)s'
# OUTPUT_TEMPLATE='%(title)s.%(ext)s'
# OUTPUT_TEMPLATE='%(uploader)s - %(title)s.%(ext)s'

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
  --convert-thumbnails png \
  --ppa "thumbnailsconvertor:-vf crop='ih:ih'" \
  --no-part \
  --force-overwrites \
  --no-cache-dir \
  "$@"
