#!/bin/sh
while true; do
   free -h | awk '/^Mem:/{print $3}' | sed 's/Gi/ G/' > $HOME/.suckless/scripts/dwmbScripts/.memory_state
   sleep 1
done

