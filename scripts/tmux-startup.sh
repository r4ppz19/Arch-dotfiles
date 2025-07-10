#!/bin/bash

SESSION="main"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Session '$SESSION' already exists. Attaching..."
  tmux attach -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n "R4PPZ"
tmux new-window -t "$SESSION:" -n "CMD"
tmux new-window -t "$SESSION:" -n "TASK"
tmux send-keys -t "$SESSION:TASK" 'btop' C-m
tmux select-window -t "$SESSION:0"
tmux attach -t "$SESSION"
