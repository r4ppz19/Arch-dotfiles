smbon() {
  sudo systemctl start smb.service nmb.service
  if systemctl is-active --quiet smb.service && systemctl is-active --quiet nmb.service; then
    echo "Samba services successfully started and active."
  else
    echo "Error: One or both Samba services failed to start." >&2
    return 1
  fi
}

smboff() {
  sudo systemctl stop smb.service nmb.service
  if ! systemctl is-active --quiet smb.service && ! systemctl is-active --quiet nmb.service; then
    echo "Samba services stopped."
  else
    echo "Error: Failed to fully stop Samba services." >&2
    return 1
  fi
}

dockeron() {
  sudo systemctl start docker.socket docker.service
  if systemctl is-active --quiet docker.service; then
    echo "Docker daemon is active."
  else
    echo "Error: Docker daemon failed to start." >&2
    return 1
  fi
}

dockeroff() {
  sudo systemctl stop docker.service docker.socket
  if ! systemctl is-active --quiet docker.service && ! systemctl is-active --quiet docker.socket; then
    echo "Docker service and socket stopped."
  else
    echo "Error: Docker frames failed to terminate completely." >&2
    return 1
  fi
}

open_file() {
  "$DOTFILES/scripts/open-file.sh"
}

rcopy() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: rcopy <source> <destination>"
    return 1
  fi
  rsync -avh --info=progress2 --partial --inplace "$@"
}

rmirror() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: rcopy <source> <destination>"
    return 1
  fi
  rsync -avh --delete --info=progress2 --partial --inplace "$@"
}

sshumount() {
  local mount_name="${1}"
  local mount_base="${HOME}/Mount"
  local mount="${mount_base}/${mount_name}"

  if [[ -z "$mount_name" ]]; then
    echo "Usage: sshumount <mount_name>"
    echo "Example: sshumount phone"
    return 1
  fi

  # Helper logic to clean up empty directories safely
  _clean_dir() {
    [[ -d "$1" ]] && rmdir "$1" 2>/dev/null
  }

  if mountpoint -q "$mount"; then
    echo "Unmounting ${mount}..."

    # Try elegant user-space unmount first, fallback to standard umount if fusermount is missing
    if command -v fusermount >/dev/null 2>&1; then
      fusermount -u "$mount"
    else
      umount "$mount"
    fi

    # Check execution status
    if [[ $? -eq 0 ]]; then
      echo "Successfully unmounted."
      _clean_dir "$mount"
      _clean_dir "$mount_base"
    else
      echo "Warning: Standard unmount failed. Device might be busy or network dropped."
      echo "Attempting lazy/force unmount..."

      # Lazy unmount detaches the filesystem immediately, even if resources are busy
      umount -l "$mount" 2>/dev/null || fusermount -z -u "$mount" 2>/dev/null

      _clean_dir "$mount"
      _clean_dir "$mount_base"
    fi
  else
    echo "No active mount found at ${mount}"
    # Clean up orphan empty folders if they exist
    _clean_dir "$mount"
    _clean_dir "$mount_base"
  fi
}

# Core execution function
_sshfs_execute() {
  local remote_host="${1}"
  local remote_path="${2}"
  local mount_name="${3}"
  local port="${4}"
  local mount_base="${HOME}/Mount"
  local mount="${mount_base}/${mount_name}"
  local extra_opts=()

  [[ -d "$mount_base" ]] || mkdir -p "$mount_base"
  [[ -d "$mount" ]] || mkdir -p "$mount"

  if mountpoint -q "$mount"; then
    echo "Target '$mount' is already a mountpoint."
    return 1
  fi

  # Dynamic check for local fuse configuration
  if grep -q "^user_allow_other" /etc/fuse.conf 2>/dev/null; then
    extra_opts=(-o "allow_other,defer_permissions,idmap=user")
  else
    extra_opts=(-o "idmap=user")
  fi

  echo "Attempting to mount ${remote_host}:${remote_path} on port ${port} to ${mount}..."

  if sshfs "${remote_host}:${remote_path}" "$mount" \
    -p "$port" \
    -o reconnect,ConnectTimeout=5,ServerAliveInterval=15 \
    "${extra_opts[@]}"; then
    echo "Successfully mounted at $mount"
  else
    echo "Mount failed."
    rmdir "$mount" 2>/dev/null
    return 1
  fi
}

# For standard Linux/macOS machines (Port 22, Default Root Path)
sshmount() {
  if [[ -z "$1" ]]; then
    echo "Usage: sshmount <ssh_alias/ip> [remote_path] [local_name]"
    return 1
  fi
  _sshfs_execute "${1}" "${2:-/}" "${3:-$1}" "22"
}

# For Termux environments (Port 8022, Strict Sandbox Path)
termuxmount() {
  if [[ -z "$1" ]]; then
    echo "Usage: termuxmount <ssh_alias/ip> [remote_path] [local_name]"
    return 1
  fi
  # Enforces the absolute path and port 8022 explicitly
  _sshfs_execute "${1}" "${2:-/data/data/com.termux/files/home}" "${3:-$1}" "8022"
}

# Encrypt a file or folder using AES-256 ZIP
ezip() {
  if [[ -z "$1" ]]; then
    echo "Usage: ezip <input_file_or_dir>"
    return 1
  fi

  local input=$1
  local output="${input%/}.zip"

  # a: add to archive
  # -tzip: use ZIP format
  # -mem=AES256: use 256-bit AES encryption
  # -p: prompt for password (securely)
  7z a -tzip -mem=AES256 -p "$output" "$input"
}

# Set the filesystem label of a block device.
fslabel() {
  local dev=$1
  local name=$2

  # Check if device exists
  if [ ! -b "$dev" ]; then
    echo "Error: $dev is not a valid block device."
    return 1
  fi

  # Detect the filesystem type
  local fstype=$(lsblk -no FSTYPE "$dev")

  case "$fstype" in
  vfat)
    sudo fatlabel "$dev" "$name"
    ;;
  exfat)
    sudo exfatlabel "$dev" "$name"
    ;;
  ext2 | ext3 | ext4)
    sudo e2label "$dev" "$name"
    ;;
  ntfs)
    sudo ntfslabel "$dev" "$name"
    ;;
  btrfs)
    sudo btrfs filesystem label "$dev" "$name"
    ;;
  *)
    echo "Error: Filesystem '$fstype' not supported by this script."
    return 1
    ;;
  esac

  echo "Successfully labeled $dev as '$name' ($fstype)"
}

# yazi
f() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) unxz "$1" ;;
    *.lzma) unlzma "$1" ;;
    *.zst) unzstd "$1" ;;
    *) echo "extract: '$1' - unknown archive method" ;;
    esac
  else
    echo "extract: '$1' is not a valid file"
  fi
}

compress() {
  if [ $# -lt 2 ]; then
    echo "Usage: compress <archive_name> <file_or_dir> [file_or_dir...]"
    return 1
  fi
  local archive="$1"
  shift
  case "$archive" in
  *.tar.gz) tar czf "$archive" "$@" ;;
  *.tar.bz2) tar cjf "$archive" "$@" ;;
  *.tar.xz) tar cJf "$archive" "$@" ;;
  *.tar.zst) tar --zstd -cf "$archive" "$@" ;;
  *.zip) zip -r "$archive" "$@" ;;
  *.7z) 7z a "$archive" "$@" ;;
  *) echo "compress: unsupported archive format: $archive" ;;
  esac
}

# Run a command on every file in the current directory
eachf() {
  find . -type f -exec "$@" {} \;
}

# Decimal to binary
dec2bin() {
  echo "obase=2; $1" | bc
}
# Binary to decimal
bin2dec() {
  echo "$((2#$1))"
}
# Binary to hex
bin2hex() {
  printf "%X\n" "$((2#$1))"
}
# Hex to binary
hex2bin() {
  echo "obase=2; ibase=16; $1" | bc
}
# Hex to decimal
hex2dec() {
  echo "$((16#$1))"
}
# Decimal to hex
dec2hex() {
  printf "%X\n" "$1"
}
# Decimal to octal
dec2oct() {
  printf "%o\n" "$1"
}
# Octal to decimal
oct2dec() {
  echo "$((8#$1))"
}
# Octal to hex
oct2hex() {
  printf "%X\n" "$((8#$1))"
}
# Hex to octal
hex2oct() {
  echo "obase=8; ibase=16; $1" | bc
}
