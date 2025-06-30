#!/bin/bash

# Google Search URL
engine_url="https://www.google.com/search?q="

# Prompt user for query
query=$(rofi -dmenu -theme "$HOME/Arch-dotfiles/rofi/custom/websearch.rasi")

# Exit if query is empty
[ -z "$query" ] && exit

# Encode query
encoded_query=$(echo "$query" | jq -s -R -r @uri)

# Launch search in default browser
xdg-open "${engine_url}${encoded_query}"
