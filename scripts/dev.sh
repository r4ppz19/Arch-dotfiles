#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"

FRONTDIR='/home/r4ppz/Project/research-repository-frontend/'
BACKDIR='/home/r4ppz/Project/research-repository-backend/'
DOCSDIR='/home/r4ppz/Project/research-repo-docs/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FRONT" -c "$FRONTDIR" -e "_TMUX_SETUP_SKIP=1"
  tmux new-window -t "$session:" -n "BACK" -c "$BACKDIR" -e "_TMUX_SETUP_SKIP=1"
  tmux new-window -t "$session:" -n "DOCS" -c "$DOCSDIR" -e "_TMUX_SETUP_SKIP=1"

  tmux send-keys -t "$session:FRONT" "v; unset _TMUX_SETUP_SKIP" C-m
  tmux send-keys -t "$session:BACK" "v; unset _TMUX_SETUP_SKIP" C-m
  tmux send-keys -t "$session:DOCS" "v; unset _TMUX_SETUP_SKIP" C-m

  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
