sshumount() {
  local mount_name="$1"
  local mount_base_dir="${HOME}/Mount"
  local mount_dir="${mount_base_dir}/${mount_name}"

  _remove_empty_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
      if rmdir "$dir"; then
        echo "Removed directory $dir"
      else
        echo "Warning: Failed to remove directory $dir (not empty or in use)"
      fi
    fi
  }

  if [[ -z "$mount_name" ]]; then
    echo "Usage: sshunmount <mount_name>"
    return 1
  fi

  if mountpoint -q "$mount_dir"; then
    if fusermount -u "$mount_dir"; then
      echo "Unmounted $mount_dir"
      _remove_empty_dir "$mount_dir"
      _remove_empty_dir "$mount_base_dir"
    else
      echo "Error: Failed to unmount $mount_dir"
      return 1
    fi
  else
    echo "No mount found at $mount_dir"
    _remove_empty_dir "$mount_dir"
    _remove_empty_dir "$mount_base_dir"
  fi
}

sshmount() {
  local remote_host="${1}"
  local remote_path="${2:-/}"
  local mount_name="${3:-$1}"
  local mount_base="${HOME}/Mount"
  local mount="${mount_base}/${mount_name}"

  if [[ -z "$remote_host" ]]; then
    echo "Usage: sshmount <ssh_alias/ip> [remote_path] [local_name]"
    echo "\nExample:"
    echo "sshmount john@192.168.1.52"
    return 1
  fi

  [[ -d "$mount_base" ]] || mkdir -p "$mount_base"
  [[ -d "$mount" ]] || mkdir -p "$mount"

  if mountpoint -q "$mount"; then
    echo "Target '$mount' is already a mountpoint."
    return 1
  fi

  echo "Attempting to mount ${remote_host}:${remote_path} to ${mount}..."

  if sshfs "${remote_host}:${remote_path}" "$mount" -o reconnect,ConnectTimeout=5,ServerAliveInterval=15,idmap=user; then
    echo "Successfully mounted at $mount"
  else
    echo "Mount failed."
    rmdir "$mount" 2>/dev/null
    return 1
  fi
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

# filter history
zshaddhistory() {
  emulate -L zsh
  # [[ $1 == *\'* || $1 == *\"* ]] && return 1
  [[ $1 == *\'* ]] && return 1
  ((${#1} > 2000)) && return 1
  return 0
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
