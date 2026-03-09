#!/bin/bash
set -euo pipefail

SESSION="${1:-main}"
FIRST_WINDOW_NAME="CMD"

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n $FIRST_WINDOW_NAME
  tmux send-keys -t "$session:$FIRST_WINDOW_NAME" "y" C-m
}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
