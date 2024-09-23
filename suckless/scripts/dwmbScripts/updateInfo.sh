#!/bin/bash

check_updates() {
    # Проверяем количество обновлений pacman
    pacman_updates=$(pacman -Qu 2>/dev/null | wc -l)
    pacman_updates=${pacman_updates:-0}  # Устанавливаем в 0, если ошибка

    # Проверяем количество обновлений yay
    aur_updates=$(yay -Qum 2>/dev/null | wc -l)
    aur_updates=${aur_updates:-0}  # Устанавливаем в 0, если ошибка

    # Проверяем количество обновлений flatpak
    if command -v flatpak >/dev/null 2>&1; then
        flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    else
        flatpak_updates=0
    fi

    # Подсчитываем общее количество обновлений
    total_updates=$((pacman_updates + aur_updates + flatpak_updates))

    # Записываем количество обновлений в файл
    echo "$total_updates" > ~/suckless/scripts/dwmbScripts/.currentInfoUpDate

    # Если есть обновления, обновляем состояние
    if [[ $total_updates -ne 0 ]]; then
        echo "$total_updates" > ~/suckless/scripts/dwmbScripts/.currentInfoUpDate
    else
        # Если обновлений нет, записываем 0
        echo "0" > ~/suckless/scripts/dwmbScripts/.currentInfoUpDate
    fi
}

while true; do
    check_updates
    sleep 40  
done

