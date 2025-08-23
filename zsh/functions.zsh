#  ╭─────────────────────────────────────────────╮
#  │                 Functions                   │
#  ╰─────────────────────────────────────────────╯

# filter history
setopt EXTENDED_HISTORY
zshaddhistory() {
  emulate -L zsh
  [[ $1 == *\'* || $1 == *\"* ]] && return 1
  return 0
}

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# tgpt with different parameter
ai() {
  case "$1" in
    -p)
      shift
      tgpt -q -w --provider pollinations "$@" ;;
    -o)
      shift
      tgpt -q -w --provider ollama --model gemma3 "$@" ;;
    *)
      tgpt -q -w "$@" ;;
  esac | mdcat | less
}

# file search
ff() {
  local file
  file=$(
    fd --type f --hidden --no-ignore . \
      | fzf \
          --preview 'bat --style=numbers --color=always {} || cat {}' \
          --preview-window=right:60%:wrap \
          --height=50% \
          --layout=reverse \
          --border \
          --bind "ctrl-d:change-preview-window(down|50%)" \
          --bind "ctrl-r:reload(fd --type f --hidden --no-ignore .)"
  )
  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

gg() {
  local file
  file=$(
    rg --hidden --no-ignore --files-with-matches "" . 2>/dev/null \
      | fzf \
          --preview 'bat --style=numbers --color=always {} || cat {}' \
          --preview-window=right:60%:wrap \
          --height=50% \
          --layout=reverse \
          --border \
          --bind "ctrl-d:change-preview-window(down|50%)" \
          --bind "ctrl-r:reload(rg --hidden --no-ignore --files-with-matches "" . 2>/dev/null)"
  )
  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
}

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

