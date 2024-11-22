#!/bin/sh
free -h | awk '/^Mem:/{print $3}' | sed 's/Gi/ G/' >  $HOME/.suckless/dwmblocks/dwmbScripts/.currentMemory

