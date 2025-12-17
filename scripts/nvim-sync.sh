#!/bin/bash
set -euo pipefail

SOURCE="/home/r4ppz/Arch-dotfiles/nvim/"
DESTINATION="/home/r4ppz/Repositories/rnvim/"
EXCLUDES=(
  '.git/'
)

if [[ ! -d "$SOURCE" ]]; then
  echo "Source directory $SOURCE does not exist."
  exit 1
fi

if [[ ! -d "$DESTINATION" ]]; then
  echo "Destination directory $DESTINATION does not exist."
  exit 1
fi

EXCLUDES_LOG=$(printf ", %s" "${EXCLUDES[@]}")
EXCLUDES_LOG=${EXCLUDES_LOG:2}

RSYNC_EXCLUDES=()
for pattern in "${EXCLUDES[@]}"; do
  RSYNC_EXCLUDES+=(--exclude="$pattern")
done

rsync -av --delete "${RSYNC_EXCLUDES[@]}" "$SOURCE" "$DESTINATION"

echo "Neovim config synced from $SOURCE to $DESTINATION."
echo "Excludes: $EXCLUDES_LOG"
