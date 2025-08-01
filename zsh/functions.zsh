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
  file=$(fd --type f --hidden . | fzf --preview 'bat --style=numbers --color=always {}' --height=50% --layout=reverse --border)
  [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

