#!/bin/bash

declare -A sites=(
    [chat]="https://chatgpt.com/"
    [fb]="https://www.facebook.com"
    [gh]="https://github.com"
    [yt]="https://www.youtube.com"
    [pins]="https://www.pinterest.com"
)

query=$(rofi -dmenu -theme "$HOME/.config/rofi/websearch/main.rasi")
[ -z "$query" ] && exit

url=${sites[$query]}
if [ -n "$url" ]; then
    xdg-open "$url"
else
    encoded_query=$(echo "$query" | jq -s -R -r @uri)
    xdg-open "https://www.google.com/search?q=${encoded_query}"
fi

