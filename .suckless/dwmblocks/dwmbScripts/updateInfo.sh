#!/bin/bash

# Определение файла для текущего значения
current_file=$HOME/.suckless/dwmblocks/dwmbScripts/.currentInfoUpDate
mkdir -p "$(dirname "$current_file")"  # Создаем директорию, если она не существует

# Функция для подсчета обновлений
count_updates() {
  local command="$1"
  local updates
  updates=$(eval "$command" 2>/dev/null | awk '/ERROR/{exit} {print}' | wc -l)

  # Если произошла ошибка, возвращаем пустую строку
  echo ${updates:-}
}

check_updates() {
  while true; do
    # Подсчет обновлений pacman, с учетом возможных ошибок
    pacman_updates=$(count_updates "checkupdates")

    # Если произошла ошибка, используем предыдущее значение из файла
    if [ -z "$pacman_updates" ]; then
      if [ -f "$current_file" ]; then
        # Читаем предыдущее значение из файла, если произошла ошибка
        formatted_updates=$(cat "$current_file")
      else
        # Если файла нет, начнем с 0
        formatted_updates=" 0"
      fi
      echo "$(date): pacman_updates (error) = $formatted_updates (from current file)"
    else
      # Форматируем вывод до фиксированной ширины (2 символа) и сохраняем текущее значение
      formatted_updates=$(printf "%2s" "$pacman_updates")
      echo "$formatted_updates" > "$current_file"
      echo "$(date): pacman_updates=$formatted_updates (current)"
    fi

    # Ожидание перед следующей проверкой
    sleep 1
  done
}

# Запуск проверки обновлений
check_updates
heck_updates
