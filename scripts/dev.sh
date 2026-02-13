#!/bin/bash
set -euo pipefail

SESSION="${1:-dev}"

FRONTDIR='/home/r4ppz/Project/research-repository-frontend/'
BACKDIR='/home/r4ppz/Project/research-repository-backend/'
DOCSDIR='/home/r4ppz/Project/research-repo-docs/'

create_tmux_session() {
  local session="$1"
  tmux new-session -d -s "$session" -n "FRONT"
  tmux new-window -t "$session:" -n "BACK"
  tmux new-window -t "$session:" -n "DOCS"

  tmux send-keys -t "$session:FRONT" "cd ${FRONTDIR}; v" C-m
  tmux send-keys -t "$session:DOCS" "cd ${DOCSDIR}; v" C-m

  local back_cmd="cd ${BACKDIR}; "
  if ! systemctl is-active --quiet docker.service || ! test -S /var/run/docker.sock; then
    back_cmd+="dockeron; "
  fi
  back_cmd+="v"

  tmux send-keys -t "$session:BACK" "$back_cmd" C-m
  tmux select-window -t "$session:0"
}

if tmux has-session -t="$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
else
  create_tmux_session "$SESSION"
  tmux attach -t "$SESSION"
fi
