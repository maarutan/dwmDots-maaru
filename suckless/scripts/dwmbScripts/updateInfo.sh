#!/bin/bash

check_updates() {
  pacman_updates=$(pacman -Qu 2>/dev/null | wc -l)
  pacman_updates=${pacman_updates:-0}

  aur_updates=$(yay -Qum 2>/dev/null | wc -l)
  aur_updates=${aur_updates:-0}

  if command -v flatpak >/dev/null 2>&1; then
    flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    flatpak_updates=${flatpak_updates:-0}
  else
    flatpak_updates=0
  fi

  total_updates=$((pacman_updates + aur_updates + flatpak_updates))

  # Логирование
  echo "$(date): pacman_updates=$pacman_updates, aur_updates=$aur_updates, flatpak_updates=$flatpak_updates, total_updates=$total_updates" >>~/suckless/scripts/dwmbScripts/update_log.txt

  echo "$total_updates" >~/suckless/scripts/dwmbScripts/.currentInfoUpDate
}

while true; do
  check_updates
  sleep 40
done
