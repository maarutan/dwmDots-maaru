#!/usr/bin/env bash
          rofi -modi window -show window -hide-scrollbar -padding 50 -line-padding 4 -auto-select \
          -kb-cancel "Alt+Escape,Escape" \
          -kb-accept-entry "!Alt-Tab,!Alt+Alt_L,Return"\
          -kb-row-down "Alt+Tab,Alt+Down" \
          -kb-row-up "Alt+ISO_Left_Tab,Alt+Up" \
          -selected-row 1 &
          while for did in $(xinput --list --id-only) ; do xinput query-state $did 2>/dev/null | grep down ; done | egrep -q . ; do sleep 0 ; done
          xdotool key --delay 0 Enter
