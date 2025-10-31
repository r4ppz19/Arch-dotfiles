#!/bin/bash
set -euo pipefail

SOURCE_BASE="/mnt/SHARED"
FOLDERS=("School" "Books" "Music" "pass")

PHONE_MOUNT="$HOME/Phone"
REMOTE="phone:/storage/emulated/0"

[ -d "$PHONE_MOUNT" ] || mkdir -p "$PHONE_MOUNT"

echo "Mounting phone"
if ! mountpoint -q "$PHONE_MOUNT"; then
  sshfs "$REMOTE" "$PHONE_MOUNT"
else
  echo "Already mounted"
fi

sync_folder() {
  local folder="$1"
  local src="$SOURCE_BASE/$folder/"
  local dest="$PHONE_MOUNT/$folder/"

  echo "Syncing $folder..."
  echo ""
  rsync -av --delete --inplace --no-perms --no-owner --no-group --mkpath "$src" "$dest" || true
}

for folder in "${FOLDERS[@]}"; do
  sync_folder "$folder"
done

echo ""
echo "Unmounting..."
if fusermount -uz "$PHONE_MOUNT"; then
  echo "Unmount successful"
  echo "Cleaning up..."
  rmdir "$PHONE_MOUNT" || echo "Could not remove mount directory (idk bro)"
else
  echo "Unmount failed"
  echo "idk why :("
fi

echo "Done ;)"
