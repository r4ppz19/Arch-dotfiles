#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"
FRONTDIR='/home/r4ppz/Project/research-repository/'
BACKDIR='/home/r4ppz/Project/backend-research-repository/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FRONT"
  tmux new-window -t "$session:" -n "FRONTAI"
  tmux new-window -t "$session:" -n "BACK"
  tmux new-window -t "$session:" -n "BACKAI"
  tmux new-window -t "$session:" -n "CMD"

  tmux send-keys -t "$session:FRONT" "cd ${FRONTDIR}; nvim" C-m
  tmux send-keys -t "$session:FRONTAI" "cd ${FRONTDIR}; qwen" C-m
  tmux send-keys -t "$session:BACK" "cd ${BACKDIR}; nvim" C-m
  tmux send-keys -t "$session:BACKAI" "cd ${BACKDIR}; qwen" C-m
  tmux send-keys -t "$session:CMD" "sudo systemctl start postgresql.service" C-m

  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
