#!/bin/bash

# Проверка наличия директории для логов
log_dir=~/suckless/scripts/dwmbScripts
mkdir -p "$log_dir"

# Функция для подсчета обновлений
count_updates() {
  local command="$1"
  local updates=$(eval "$command" 2>/dev/null | awk '/ERROR/{exit} {print}' | wc -l)
  echo ${updates:-0} # Возвращаем 0, если обновлений нет
}

check_updates() {
  while true; do
    # Подсчет обновлений pacman
    pacman_updates=$(count_updates "checkupdates")

    # Логирование
    echo "$(date): pacman_updates=$pacman_updates" >>"$log_dir/update_log.txt"

    # Сохранение текущего количества обновлений
    echo "$pacman_updates" >"$log_dir/.currentInfoUpDate"

    # Ожидание перед следующей проверкой
    sleep 1
  done
}

# Запуск проверки обновлений
check_updates
