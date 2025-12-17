#!/bin/bash
set -euo pipefail

SOURCE_BASE="/mnt/SHARED"
FOLDERS=("School" "Books" "Music" "pass")

PHONE_MOUNT="$HOME/Phone"
REMOTE="phone:/storage/emulated/0"

[ -d "$PHONE_MOUNT" ] || mkdir -p "$PHONE_MOUNT"

printf "Mounting phone\n"
if ! mountpoint -q "$PHONE_MOUNT"; then
  sshfs "$REMOTE" "$PHONE_MOUNT"
else
  printf "Already mounted\n"
fi

sync_folder() {
  local folder="$1"
  local src="$SOURCE_BASE/$folder/"
  local dest="$PHONE_MOUNT/$folder/"

  printf "\n-------------------------------------\n"
  printf "Syncing $folder..."
  printf "\n-------------------------------------\n"

  rsync -av --delete --inplace --no-perms --no-owner --no-group --mkpath "$src" "$dest" || true
}

for folder in "${FOLDERS[@]}"; do
  sync_folder "$folder"
done

printf "\nUnmounting...\n"
if fusermount -uz "$PHONE_MOUNT"; then
  printf "Unmount successful\n"
  printf "Cleaning up...\n"
  rmdir "$PHONE_MOUNT" || printf "Could not remove mount directory\n"
else
  printf "Unmount failed\n"
  printf "idk why :(\n"
fi

printf "Done ;)\n"
