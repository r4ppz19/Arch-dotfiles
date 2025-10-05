#!/bin/bash

TEMP=$(sensors 2>/dev/null | awk '/^Package id 0:/ {gsub(/\+|°C/,"",$4); print int($4); exit}')

if [ -z "$TEMP" ]; then
  TEMP=0
fi

if [ "$TEMP" -ge 80 ]; then
  CLASS="critical"
elif [ "$TEMP" -ge 70 ]; then
  CLASS="warning"
else
  CLASS="normal"
fi

echo "{\"text\": \"$TEMP\", \"class\": \"$CLASS\"}"
