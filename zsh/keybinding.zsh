bindkey -e # emacs mode

# Modern word jumps (Ctrl+←/→)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# File picker
zle -N open_file
bindkey '^[f' open_file
