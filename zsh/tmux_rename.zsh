# Tmux auto‑rename script
# Renames the current tmux window based on the running command or cwd.
# Priority: PROC_MAP (command) → DIR_MAP_UNIQUE → DIR_MAP → DIR_MAP_PREFIX → fallback "CMD".
# Hooks: preexec (command) and precmd (directory).
# Skips renaming when not in tmux, NVIM is set, window is locked, or multiple panes.

typeset -gA PROC_MAP=(
  q LLM
  f FILE
  nv NVIM
  op LLM
  ai LLM
  cline LLM
  crush LLM
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
  cliamp MUSIC
  music MUSIC
  sudo SUDO
  cargo CARGO
  gdu GDU
  witr WITR
  rss RSS
  bulletty RSS
)

typeset -gA DIR_MAP=(
  "/" ROOT
  "$HOME" HOME
)

typeset -gA DIR_MAP_UNIQUE=(
  # Configs
  "$HOME/Arch-dotfiles" DOTS
  "$HOME/Arch-dotfiles/nvim" VDOTS

  # Personal projects
  "$HOME/Repositories/projects" PROJECTS

  "$HOME/Repositories/projects/r4ppz.github.io" PWEB
  "$HOME/Repositories/projects/minidm" MINIDM
  "$HOME/Repositories/nvplug/lspeek.nvim" LSPEEK
  "$HOME/Repositories/projects/minidm" MINIDM

  # School projects/capstone

  # Project 1
  "$HOME/Repositories/projects/research-repository" ACDRR
  "$HOME/Repositories/projects/research-repository/docs" DOCS
  "$HOME/Repositories/projects/research-repository/backend" BACK
  "$HOME/Repositories/projects/research-repository/frontend" FRONT

  # Project 2
  "$HOME/Repositories/projects/mini-capstone/law-firm-management-system" LFMS
  "$HOME/Repositories/projects/mini-capstone/documentation" DOCS

  # Project 3
  "$HOME/Repositories/projects/pacy" PACY
)

typeset -gA DIR_MAP_PREFIX=(
  "/etc" ETC
  "/mnt" MOUNT
  "/tmp" TEMP
  "/run/media" MOUNT
  "/mnt/SHARED" SHARED
  "/mnt/SHARED/Music (Better)/" MUSIC

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
  "$HOME/Documents/notes" NOTES

  "$HOME/Repositories/projects" PROJECTS
  "$HOME/Repositories" REPOS
  "$HOME/.config" DOTS
  "$HOME/Arch-dotfiles" DOTS

  "$HOME/Repositories/projects/mini-capstone" CAPTS
)

# Helpers
_tmux_is_renamable() {
  [[ -z $TMUX || -n $NVIM ]] && return 1

  local tmux_state
  tmux_state=$(tmux display-message -p '#{window_panes}|#{@tmux_rename_locked}' 2>/dev/null)

  local pane_count="${tmux_state%%|*}"
  local lock_value="${tmux_state##*|}"

  [[ $lock_value == (1|on) ]] && return 1
  ((pane_count > 1)) && return 1

  return 0
}

# Returns 0 (available) if no window other than the current one uses the given label.
_tmux_label_available() {
  local label="$1"
  local current_window="$2"
  shift 2
  local -a all_windows=("$@")

  # Already named this label — no conflict
  [[ $label == $current_window ]] && return 0

  for window_name in "${all_windows[@]}"; do
    [[ $window_name == $label ]] && return 1
  done
  return 0
}

# Hooks
_tmux_rename_preexec() {
  _tmux_is_renamable || return 0

  local -a cmd_args=(${(z)1})
  local cmd="${cmd_args[1]##*/}"

  [[ -z $cmd || $cmd == (zsh|bash|sh) ]] && return 0

  local name="${PROC_MAP[$cmd]}"
  [[ -n $name ]] && tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
}

_tmux_rename_precmd() {
  _tmux_is_renamable || return 0

  local clean_pwd="${PWD%/}"
  [[ -z $clean_pwd ]] && clean_pwd="/"

  local target_name="CMD"
  local unique_candidate="${DIR_MAP_UNIQUE[$clean_pwd]}"

  if [[ -n $unique_candidate ]]; then
    local tmux_data
    tmux_data=$(tmux display-message -p '#{window_name}' \; list-windows -F '#{window_name}' 2>/dev/null)

    local current_window_name="${tmux_data%%$'\n'*}"
    local all_data="${tmux_data#*$'\n'}"
    local -a window_names=("${(f)all_data}")

    if _tmux_label_available "$unique_candidate" "$current_window_name" "${window_names[@]}"; then
      target_name="$unique_candidate"
    else
      target_name="CMD"
    fi
  else
    target_name="${DIR_MAP[$clean_pwd]}"
    if [[ -z $target_name ]]; then
      local prefix_match=""
      for k in "${(@k)DIR_MAP_PREFIX}"; do
        if [[ $clean_pwd == "$k" || $clean_pwd == "$k"/* && ${#k} -gt ${#prefix_match} ]]; then
          prefix_match="$k"
        fi
      done
      target_name="${DIR_MAP_PREFIX[$prefix_match]:-CMD}"
    fi
  fi

  tmux rename-window -t "$TMUX_PANE" "$target_name" 2>/dev/null
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_rename_preexec
add-zsh-hook precmd _tmux_rename_precmd
