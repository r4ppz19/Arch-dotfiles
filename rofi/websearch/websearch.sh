#!/bin/bash

declare -A sites=(
    [chat]="https://chatgpt.com/"
    [fb]="https://www.facebook.com"
    [gh]="https://github.com/r4ppz19"
    [yt]="https://www.youtube.com"
    [pins]="https://www.pinterest.com"
    [mail]="https://mail.google.com/mail/u/0/#inbox"
    [movie]="https://hurawatchtv.tv/home"
    [book]="https://annas-archive.org/"
    [music]="https://open.spotify.com/"
    [figma]="https://www.figma.com/files/team/1453677715883679951/drafts?fuid=1453677713981521812"
    [olsis]="https://tsis.assumptiondavao.edu.ph/"
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

