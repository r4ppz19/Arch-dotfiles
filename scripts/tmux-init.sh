#!/bin/bash
set -euo pipefail

SESSION="${1:-main}"

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "CMD"
  tmux send-keys -t "$session:CMD" "y" C-m
}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
