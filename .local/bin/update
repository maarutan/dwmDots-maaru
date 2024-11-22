#!/bin/bash

# Цвета для вывода текста
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_CYAN='\033[0;36m'
COLOR_BLUE='\033[1;34m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Проверка наличия необходимых приложений
required_apps=(neofetch figlet notify-send)
missing_apps=()

for app in "${required_apps[@]}"; do
  if ! command -v $app &>/dev/null; then
    missing_apps+=($app)
  fi
done

if [ ${#missing_apps[@]} -ne 0 ]; then
  echo -e "${COLOR_RED}Ошибка: Для корректной работы скрипта необходимо установить следующие приложения: ${missing_apps[*]}${COLOR_RESET}"
  exit 1
fi

# Файл для текущего значения обновлений pacman
current_file=$HOME/.suckless/scripts/dwmbScripts/.currentInfoUpDate
mkdir -p "$(dirname "$current_file")" # Создаем директорию, если она не существует

# Функция для подсчета обновлений с обработкой ошибок
count_updates() {
  local command="$1"
  local updates
  updates=$(eval "$command" 2>/dev/null | awk '/ERROR/{exit} {print}' | wc -l)

  # Если произошла ошибка, возвращаем пустую строку
  echo ${updates:-}
}

# Функция для проверки обновлений
check_updates() {
  while true; do
    # Подсчет обновлений pacman с учетом возможных ошибок
    pacman_updates=$(count_updates "checkupdates")
    if [ -z "$pacman_updates" ]; then
      # Если произошла ошибка, используем предыдущее значение из файла
      if [ -f "$current_file" ]; then
        formatted_pacman_updates=$(cat "$current_file")
      else
        formatted_pacman_updates="0"
      fi
    else
      # Сохраняем текущее значение и обновляем файл
      formatted_pacman_updates=$(printf "%2s" "$pacman_updates")
      echo "$formatted_pacman_updates" >"$current_file"
    fi
    echo -e "${COLOR_YELLOW}===> pacman     󰮯   ~~> : $formatted_pacman_updates${COLOR_RESET}"

    # Подсчет обновлений yay
    yay_updates=$(count_updates "yay -Qu")
    formatted_yay_updates=${yay_updates:-0}
    echo -e "${COLOR_GREEN}===> yay        󰣇   ~~> :  $formatted_yay_updates${COLOR_RESET}"

    # Подсчет обновлений flatpak
    flatpak_updates=$(count_updates "flatpak remote-ls --updates")
    formatted_flatpak_updates=${flatpak_updates:-0}
    echo -e "${COLOR_CYAN}===> flatpak       ~~> :  $formatted_flatpak_updates${COLOR_RESET}"
    sleep 2

    # Общий подсчет обновлений
    total_updates=$((pacman_updates + yay_updates + flatpak_updates))
    echo -e "${COLOR_YELLOW}Общее количество обновлений: ${total_updates}${COLOR_RESET}"

    # Уведомление через notify-send об общем количестве обновлений
    notify-send "Обновления системы" "Доступно $total_updates обновлений"
    break
  done
}

# Функция обновления системы
update_system() {
  # Обновление pacman (всегда)
  echo -e "${COLOR_BLUE}Требуется ввести пароль для продолжения выполнения команд с правами суперпользователя.${COLOR_RESET}"
  notify-send "Требуется пароль" "Введите пароль для продолжения работы"
  echo -e "${COLOR_YELLOW}\n=== Обновление pacman ===${COLOR_RESET}"
  if ! sudo pacman -Syu --noconfirm; then
    echo -e "${COLOR_RED}Ошибка обновления через pacman!${COLOR_RESET}"
    notify-send "Ошибка обновления" "Pacman не смог обновиться"
  fi

  # Обновление yay (всегда)
  echo -e "${COLOR_GREEN}\n=== Обновление yay ===${COLOR_RESET}"
  if ! yay -Syu --noconfirm; then
    echo -e "${COLOR_RED}Ошибка обновления через yay!${COLOR_RESET}"
    notify-send "Ошибка обновления" "Yay не смог обновиться"
  fi

  # Обновление flatpak (всегда)
  echo -e "${COLOR_CYAN}\n=== Обновление flatpak ===${COLOR_RESET}"
  if ! flatpak update -y; then
    echo -e "${COLOR_RED}Ошибка обновления через flatpak!${COLOR_RESET}"
    notify-send "Ошибка обновления" "Flatpak не смог обновиться"
  fi
}

# Функция для вызова neofetch или альтернативных fetch
fetch_alternative() {
  if [ -f "$HOME/.config/neofetch/startFetch.py" ]; then
    python $HOME/.config/neofetch/startFetch.py &>/dev/null & # Фоновый запуск startFetch.py
    wait $!                                                   # Ожидание завершения фонового процесса
    if command -v neofetch &>/dev/null; then
      neofetch
    elif command -v fetch &>/dev/null; then
      fetch
    elif [ -f "$HOME/.suckless/scripts/fetch.sh" ]; then
      /home/maaru/suckless/scripts/fetch.sh
    elif command -v fastfetch &>/dev/null; then
      fastfetch
    else
      echo -e "${COLOR_RED}Ошибка: Не удалось найти ни одну из программ для вывода системной информации.${COLOR_RESET}"
    fi
  elif command -v neofetch &>/dev/null; then
    neofetch
  elif command -v fetch &>/dev/null; then
    fetch
  elif [ -f "$HOME/.suckless/scripts/fetch.sh" ]; then
    $HOME/.suckless/scripts/fetch.sh
  elif command -v fastfetch &>/dev/null; then
    fastfetch
  else
    echo -e "${COLOR_RED}Ошибка: Не удалось найти ни одну из программ для вывода системной информации.${COLOR_RESET}"
  fi
}

# Вызов скрипта neofetch в начале
fetch_alternative

# Проверка обновлений
check_updates

# Обновление системы (независимо от наличия обновлений)
update_system

# Очистка терминала и вызов neofetch после обновления
clear
fetch_alternative

# Вывод прощального сообщения с использованием figlet и радужного окраса
bye_message=$(figlet -f mini "' -->  bye  <-- '")
bye_user_message=$(figlet -f mini "' -->  $(echo $USER) ^^  <-- '")

echo "$bye_message"
echo "$bye_message"
echo "$bye_user_message"

# Ожидание перед завершением
sleep 5
