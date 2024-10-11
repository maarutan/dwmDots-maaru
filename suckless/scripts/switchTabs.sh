#!/bin/bash

if [ "$1" == "right" ]; then
    xdotool key --clearmodifiers alt+Right
elif [ "$1" == "left" ]; then
    xdotool key --clearmodifiers alt+Left
fi

