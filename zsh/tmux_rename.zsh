# Tmux auto-rename

# Prio:
# 1 PROC_MAP (commands)
# 2 DIR_MAP_UNIQUE (unique directories)
# 3 DIR_MAP (general directories)
# 4 CMD (default)

typeset -gA PROC_MAP=(
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
  blue BLUET
  net NET
  lg GIT
  ld DOCKER
  yay YAY
  npm NPM
  late LATE
  ssh SSH
  tetro-tui TETRIS
  kew MUSIC
  sudo SUDO
)

typeset -gA DIR_MAP=(
  "/" ROOT
  "/etc" ETC
  "/mnt" MOUNT
  "/tmp" TEMP
  "/run/media" MOUNT
  "/mnt/SHARED" SHARED

  "$HOME" HOME
  "$HOME/.config" DOTS
  "$HOME/.local" LOCAL
  "$HOME/Books" BOOKS
  "$HOME/School" SCHOOL
  "$HOME/Music" MUSIC
  "$HOME/Documents" DOCUMENTS
  "$HOME/Downloads" DOWNLOADS
  "$HOME/Games" GAMES
  "$HOME/Pictures" PICS
  "$HOME/Repositories" REPOS
  "$HOME/Vault" VAULT
  "$HOME/Videos" VIDS
)

typeset -gA DIR_MAP_UNIQUE=(
  "$HOME/Arch-dotfiles" DOTS
  "$HOME/Arch-dotfiles/nvim" VDOTS

  "$HOME/Projects" PROJECTS
  "$HOME/Projects/r4ppz.github.io" PWEB
  "$HOME/Projects/research-repository" RESEARCH
  "$HOME/Projects/research-repository/docs" DOCS
  "$HOME/Projects/research-repository/backend" BACK
  "$HOME/Projects/research-repository/frontend" FRONT
)

_tmux_is_renamable() {
  [[ -z "$TMUX" || -n "$NVIM" ]] && return 1

  local tmux_state
  tmux_state=$(tmux display-message -p '#{window_panes}|#{@tmux_rename_locked}' 2>/dev/null)

  [[ "$tmux_state" == *"|1"* || "$tmux_state" == *"|on"* ]] && return 1
  [[ "${tmux_state%%|*}" -gt 1 ]] && return 1

  return 0
}

_tmux_rename_preexec() {
  _tmux_is_renamable || return 0

  local -a cmd_args=(${(z)1})
  local cmd="${cmd_args[1]##*/}"

  [[ -z "$cmd" || "$cmd" == (zsh|bash|sh) ]] && return 0

  local name="${PROC_MAP[$cmd]}"
  [[ -n "$name" ]] && tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
}

_tmux_rename_precmd() {
  _tmux_is_renamable || return 0

  local clean_pwd="${PWD%/}"
  [[ -z "$clean_pwd" ]] && clean_pwd="/"

  local target_name="CMD"
  local unique_candidate="${DIR_MAP_UNIQUE[$clean_pwd]}"

  if [[ -n "$unique_candidate" ]]; then
    local tmux_data
    tmux_data=$(tmux display-message -p '#{window_name}' \; list-windows -F '#{window_name}' 2>/dev/null)

    local current_window_name="${tmux_data%%$'\n'*}"
    local all_windows="${tmux_data#*$'\n'}"

    if [[ "$unique_candidate" != "$current_window_name" && "$all_windows" == (*$'\n'"$unique_candidate"$'\n'*|"$unique_candidate"$'\n'*|*$'\n'"$unique_candidate") ]]; then
      target_name="CMD"
    else
      target_name="$unique_candidate"
    fi
  else
    target_name="${DIR_MAP[$clean_pwd]:-CMD}"
  fi

  tmux rename-window -t "$TMUX_PANE" "$target_name" 2>/dev/null
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_rename_preexec
add-zsh-hook precmd _tmux_rename_precmd
