#!/bin/bash
set -euo pipefail

SEARCH_DIR="${1:-$HOME}"
EDITOR="${EDITOR:-nvim}"

if command -v bat &>/dev/null; then
  PREVIEW_CMD="bat --style=numbers --color=always --line-range=:500 {}"
else
  PREVIEW_CMD="cat {}"
fi

# Excluded file patterns
EXCLUDED_EXTENSIONS=(
  '*.jpg' '*.jpeg' '*.png' '*.gif' '*.bmp' '*.tiff' '*.webp' '*.ico'
  '*.pdf' '*.epub' '*.doc' '*.docx' '*.xls' '*.xlsx' '*.ppt' '*.pptx'
  '*.mp3' '*.wav' '*.flac' '*.ogg' '*.m4a' '*.wma' '*.aac'
  '*.mp4' '*.mkv' '*.webm' '*.avi' '*.mov' '*.flv' '*.wmv'
  '*.zip' '*.tar' '*.gz' '*.bz2' '*.xz' '*.7z' '*.rar' '*.iso'
  '*.ttf' '*.otf' '*.woff' '*.woff2'
  '*.exe' '*.dll' '*.so' '*.bin' '*.class' '*.o' '*.a'
)

# Build fd exclude args
EXCLUDES=()
for pattern in "${EXCLUDED_EXTENSIONS[@]}"; do
  EXCLUDES+=(--exclude "$pattern")
done

# Run inside a tmux popup
fd --type f --hidden --follow --exclude .git "${EXCLUDES[@]}" . "$SEARCH_DIR" 2>/dev/null | \
fzf-tmux -p 80%,70% --reverse \
  --ansi \
  --prompt='Search: ' \
  --marker='▶' \
  --preview "$PREVIEW_CMD" \
  --preview-window="right:50%" \
  --height=100% \
  --border \
| xargs -r -- "$EDITOR"

