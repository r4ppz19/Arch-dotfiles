#!/bin/bash

search_engine="https://duckduckgo.com/?q="

query=$(rofi -dmenu -theme "$HOME/.config/rofi/websearch/main.rasi")

[[ -z $query ]] && exit

# Trim leading and trailing whitespace
query="${query#"${query%%[![:space:]]*}"}"
query="${query%"${query##*[![:space:]]}"}"

if [[ -n $url ]]; then
  xdg-open "$url"
elif [[ $query =~ ^https?:// ]]; then
  xdg-open "$query"
elif [[ $query == *.* && $query != *[[:space:]]* ]]; then
  xdg-open "https://$query"
else
  encoded_query=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote_plus(sys.argv[1]))" "$query")
  xdg-open "${search_engine}${encoded_query}"
fi
