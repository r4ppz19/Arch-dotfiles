#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"

FRONTDIR='/home/r4ppz/Project/research-repository-frontend/'
BACKDIR='/home/r4ppz/Project/research-repository-backend/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FRONT"
  tmux new-window -t "$session:" -n "BACK"
  tmux new-window -t "$session:" -n "DOCKER"

  tmux send-keys -t "$session:FRONT" "cd ${FRONTDIR}; v" C-m
  tmux send-keys -t "$session:BACK" "cd ${BACKDIR}; v" C-m
  tmux send-keys -t "$session:DOCKER" "cd ${BACKDIR}; lazydocker" C-m

  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
