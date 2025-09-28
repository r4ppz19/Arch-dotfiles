#!/bin/bash

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ]; then
  tmux detach-client
else
  tmux popup -d '#{pane_current_path}' -xC -yC -w80% -h80% -E "tmux attach -t popup || tmux new -s popup; tmux set-option status off"
fi

