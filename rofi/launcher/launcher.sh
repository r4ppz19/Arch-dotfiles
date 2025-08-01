#!/usr/bin/env bash

dir="$HOME/.config/rofi/launcher"
theme='main'

# Run
rofi \
  -show drun \
  -theme ${dir}/${theme}.rasi
