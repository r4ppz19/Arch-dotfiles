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
  lg GIT
  ld DOCKER
  yay UPDATE
  npm update -g UPDATE
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
  $HOME/Documents DOCUMENTS
  $HOME/Downloads DOWNLOADS
  $HOME/Games GAMES
  $HOME/Pictures PICS
  $HOME/Repositories REPOS
  $HOME/Vault VAULT
  $HOME/Videos VIDS

  $HOME/Projects PROJECTS
  $HOME/Projects/r4ppz.github.io PWEB
  $HOME/Projects/research-repository RESEARCH
  $HOME/Projects/research-repository/docs DOCS
  $HOME/Projects/research-repository/backend BACK
  $HOME/Projects/research-repository/frontend FRONT
)

_tmux_should_skip() {
  [[ -z $TMUX || -n $NVIM ]] && return 0

  # Skip if there is more than 1 pane in the current window
  local panes
  panes=$(tmux display-message -p '#{window_panes}' 2>/dev/null)
  [[ ${panes:-1} -gt 1 ]]
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
  [[ -n $name ]] && tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
}

_tmux_rename_precmd() {
  _tmux_should_skip && return 0

  # Clean PWD of trailing slash (except if it's strictly root '/')
  local clean_pwd="${PWD%/}"
  [[ -z $clean_pwd ]] && clean_pwd="/"

  # Priority: dir name → CMD fallback
  local dir_name="${DIR_MAP[$clean_pwd]:-CMD}"

  # echo "DEBUG PRECMD: PWD='$clean_pwd' -> dir_name='$dir_name'" >&2

  tmux rename-window -t "$TMUX_PANE" "$dir_name" 2>/dev/null
  # echo "DEBUG: Renamed window to '$dir_name'" >&2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_rename_preexec
add-zsh-hook precmd _tmux_rename_precmd
