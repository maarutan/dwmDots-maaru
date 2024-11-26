#!/usr/bin/env bash
 


dir="$HOME/.config/rofi/launchers/type-2"
theme='window'

## Run
rofi \
    -show window \
    -theme ${dir}/${theme}.rasi
