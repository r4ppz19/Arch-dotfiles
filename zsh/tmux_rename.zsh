# Tmux window auto-rename
# Fallback to CMD default name

typeset -A PROC_MAP=(
  q LLM
  f FILE
  nv EDIT
  op LLM
  top TASK
  ollama LLM
  news NEWS
  pac PAC
  pgcli DB
  lnav LOGS
  bluetuith BT
  net NET
  yay UPDATE
  lg GIT
  ld DOCKER
)

typeset -A DIR_MAP=(
  / ROOT
  /etc ETC
  /mnt/SHARED SHARED
  /run/media MOUNT
  /tmp TEMP
  $HOME HOME
  $HOME/Arch-dotfiles DOTS
  $HOME/Arch-dotfiles/nvim VDOTS
  $HOME/.config DOTS
  $HOME/.local LOCAL
  $HOME/Books BOOKS
  $HOME/School SCHOOL
  $HOME/Music MUSIC
  $HOME/Documents DOCS
  $HOME/Downloads DL
  $HOME/Games GAMES
  $HOME/Pictures PICS
  $HOME/Repositories REPOS
  $HOME/Vault VAULT
  $HOME/Videos VIDS

  $HOME/Project PROJECT
  $HOME/Project/research-repository-backend BACK
  $HOME/Project/research-repository-frontend FRONT
  $HOME/Project/research-repo-docs DOCS
)

_tmux_should_skip() {
  [[ -z $TMUX || -n $NVIM || -n ${_TMUX_SETUP_SKIP:-} ]]
}

_tmux_rename_preexec() {
  _tmux_should_skip && return 0

  # Split command line into array, then get first element
  local -a cmd_line
  cmd_line=(${(z)1})
  local raw_cmd=$cmd_line[1]
  local cmd=${raw_cmd##*/}

  # Skip empty commands or shells
  [[ -z $cmd || $cmd == (zsh|bash|sh) ]] && return 0

  local name=$PROC_MAP[$cmd]
  [[ -n $name ]] && tmux rename-window -t : "$name" 2>/dev/null
}

_tmux_rename_precmd() {
  _tmux_should_skip && return 0

  # Priority: dir name → CMD fallback
  local dir_name="${DIR_MAP[$PWD]:-CMD}"

  # Debug: uncomment to troubleshoot
  # echo "DEBUG PRECMD: PWD='$PWD' -> dir_name='$dir_name'" >&2

  tmux rename-window -t : "$dir_name" 2>/dev/null
  # echo "DEBUG: Renamed window to '$dir_name'" >&2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_rename_preexec
add-zsh-hook precmd _tmux_rename_precmd
