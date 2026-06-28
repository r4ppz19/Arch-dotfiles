#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"

FRONTDIR='/home/r4ppz/Projects/research-repository/frontend'
BACKDIR='/home/r4ppz/Projects/research-repository/backend/'
DOCSDIR='/home/r4ppz/Projects/research-repository/docs/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FRONT" -c "$FRONTDIR"
  tmux new-window -t "$session:" -n "BACK" -c "$BACKDIR"
  tmux new-window -t "$session:" -n "DOCS" -c "$DOCSDIR"

  tmux send-keys -t "$session:FRONT" "v" C-m
  tmux send-keys -t "$session:BACK" "v" C-m
  tmux send-keys -t "$session:DOCS" "v" C-m

  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
