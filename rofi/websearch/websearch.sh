#!/bin/bash

declare -A sites=(
  [fb]="https://www.facebook.com/messages"
  [gh]="https://github.com/r4ppz"
  [yt]="https://www.youtube.com"
  [red]="https://www.reddit.com/"
  [pins]="https://www.pinterest.com"
  [mail]="https://mail.google.com/mail/u/0/#inbox"
  [movie]="https://movielair.cc/"
  [book]="https://annas-archive.se/"
  [music]="https://open.spotify.com/"
  [figma]="https://www.figma.com/"
  [olsis]="https://tsis.assumptiondavao.edu.ph/"
  [icon]="https://lucide.dev/icons/"
  [read]="https://medium.com/"
  [framer]="https://framer.com/projects/"
  [dev]="https://devdocs.io/"
  [wifi]="http://192.168.1.254/"
  [docs]="https://r4ppz.github.io/research-repo-docs/"
  [drive]="https://drive.google.com/drive/my-drive"
  [dhub]="https://hub.docker.com/repositories/r4ppzf"
)

search_engine="https://duckduckgo.com/?q="

query=$(rofi -dmenu -theme "$HOME/.config/rofi/websearch/main.rasi")

[ -z "$query" ] && exit

url=${sites[$query]}

if [ -n "$url" ]; then
  xdg-open "$url"
elif [[ $query =~ ^https?:// ]]; then
  xdg-open "$query"
else
  encoded_query=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.argv[1]))" "$query")
  xdg-open "${search_engine}${encoded_query}"
fi
