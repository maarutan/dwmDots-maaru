#!/usr/bin/env bash

dir="$HOME/.config/rofi/emoji"
theme='emoji'

## Run
rofi \
    -show emoji -kb-custom-1 Ctrl+c \
    -theme ${dir}/${theme}.rasi
