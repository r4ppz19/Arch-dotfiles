#!/bin/bash
set -euo pipefail

SESSION="${1:-main}"

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "R4PPZ"
  tmux new-window -t "$session:" -n "CMD"
  tmux new-window -t "$session:" -n "TASK"
  tmux send-keys -t "$session:CMD" 'y' C-m
  tmux send-keys -t "$session:TASK" 'btop' C-m
  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi

