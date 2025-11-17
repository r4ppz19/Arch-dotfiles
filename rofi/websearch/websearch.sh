#!/bin/bash

declare -A sites=(
  [fb]="https://www.facebook.com/messages"
  [gh]="https://github.com/r4ppz"
  [yt]="https://www.youtube.com"
  [red]="https://www.reddit.com/"
  [pins]="https://www.pinterest.com"
  [mail]="https://mail.google.com/mail/u/0/#inbox"
  [movie]="https://hurawatchtv.tv/home"
  [book]="https://annas-archive.org/"
  [music]="https://open.spotify.com/"
  [figma]="https://www.figma.com/"
  [olsis]="https://tsis.assumptiondavao.edu.ph/"
  [icon]="https://lucide.dev/icons/"
  [read]="https://medium.com/"
  [framer]="https://framer.com/projects/"
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
