#!/bin/bash
set -euo pipefail

CIPHER_DIR="$HOME/Vault"
MOUNT_POINT="$HOME/Vault.Mounted"

lock_vault() {
  if mountpoint -q "$MOUNT_POINT"; then
    echo "Unmounting $MOUNT_POINT..."
    fusermount -u "$MOUNT_POINT"

    if [ $? -eq 0 ]; then
      rmdir "$MOUNT_POINT"
      echo "Vault locked and mount point removed."
    else
      fusermount -uz "$MOUNT_POINT"
      echo "Vault locked and mount point removed (lazy)."
      if [ $? -eq 0 ]; then
        echo "Error: Could not unmount. Is a file or terminal still open in the vault?"
      fi
      exit 1
    fi
  else
    echo "Vault is not currently mounted."
  fi
}

unlock_vault() {
  if [[ ! -d "$CIPHER_DIR" ]]; then
    echo "Error: Ciphertext directory $CIPHER_DIR does not exist."
    exit 1
  fi

  mkdir -p "$MOUNT_POINT"

  echo "Unlocking $CIPHER_DIR..."
  gocryptfs "$CIPHER_DIR" "$MOUNT_POINT"

  if [ $? -eq 0 ]; then
    echo "Vault unlocked at $MOUNT_POINT"
  else
    rmdir "$MOUNT_POINT"
    exit 1
  fi
}

case "$1" in
open | unlock)
  unlock_vault
  ;;
close | lock)
  lock_vault
  ;;
*)
  echo "Usage: $0 {open|close}"
  exit 1
  ;;
esac
