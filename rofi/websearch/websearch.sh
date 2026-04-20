#!/usr/bin/env bash

declare -A sites=(
  [fb]="https://www.facebook.com/messages"
  [gh]="https://github.com/r4ppz"
  [ghg]="https://gist.github.com/r4ppz"
  [cb]="https://codeberg.org/r4ppz"
  [yt]="https://www.youtube.com"
  [red]="https://www.reddit.com"
  [pin]="https://www.pinterest.com"
  [dev]="https://app.daily.dev"
  [mail]="https://mail.google.com"
  [movie]="https://movielair.cc"
  [book]="https://annas-archive.li"
  [music]="https://music.youtube.com"
  [figma]="https://www.figma.com"
  [olsis]="https://tsis.assumptiondavao.edu.ph"
  [icon]="https://lucide.dev/icons"
  [read]="https://medium.com"
  [framer]="https://framer.com/projects"
  [drive]="https://drive.google.com/drive/my-drive"
  [docker]="https://hub.docker.com/repositories/r4ppzf"
  [canva]="https://www.canva.com"
  [speed]="https://www.speedtest.net"
  [wifi]="http://192.168.1.254"
)

search_engine="https://duckduckgo.com/?q="

query=$(rofi -dmenu -theme "$HOME/.config/rofi/websearch/main.rasi")

[ -z "$query" ] && exit

# Trim leading and trailing whitespace
query="${query#"${query%%[![:space:]]*}"}"
query="${query%"${query##*[![:space:]]}"}"

url=${sites[$query]}

if [ -n "$url" ]; then
  xdg-open "$url"
elif [[ $query =~ ^https?:// ]]; then
  xdg-open "$query"
else
  encoded_query=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.argv[1]))" "$query")
  xdg-open "${search_engine}${encoded_query}"
fi
