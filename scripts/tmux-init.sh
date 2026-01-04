#!/bin/bash
set -euo pipefail

SESSION="${1:-main}"

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "R4PPZ"
  tmux send-keys -t "$session:R4PPZ" "y" C-m
}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
