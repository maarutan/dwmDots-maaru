#!/bin/bash

# Цвета для вывода текста
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Функция для проверки обновлений
check_updates() {
  # Проверка обновлений pacman
  pacman_updates=$(checkupdates 2>/dev/null | awk '/ERROR/{exit} {print}' | wc -l)
  echo -e "${COLOR_YELLOW}===> pacman     󰮯   ~~> : ${pacman_updates}${COLOR_RESET}"

  # Проверка обновлений yay
  yay_updates=$(yay -Qu 2>/dev/null | wc -l)
  echo -e "${COLOR_GREEN}===> yay        󰣇   ~~> : ${yay_updates}${COLOR_RESET}"

  # Проверка обновлений flatpak
  flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
  echo -e "${COLOR_CYAN}===> flatpak       ~~> : ${flatpak_updates}${COLOR_RESET}"

  # Вывод общего количества обновлений
  total_updates=$((pacman_updates + yay_updates + flatpak_updates))
  echo -e "${COLOR_BLUE}Общее количество обновлений: ${total_updates}${COLOR_RESET}"
}

# Функция обновления системы
update_system() {
  echo -e "${COLOR_YELLOW}\n=== Обновление pacman ===${COLOR_RESET}"
  if ! sudo pacman -Syu --noconfirm; then
    echo -e "${COLOR_RED}Ошибка обновления через pacman!${COLOR_RESET}"
    return 1
  fi

  echo -e "${COLOR_GREEN}\n=== Обновление yay 󰣇 ===${COLOR_RESET}"
  if ! yay -Syu --noconfirm; then
    echo -e "${COLOR_RED}Ошибка обновления через yay!${COLOR_RESET}"
    return 1
  fi

  echo -e "${COLOR_CYAN}\n=== Обновление flatpak ===${COLOR_RESET}"
  if ! flatpak update -y; then
    echo -e "${COLOR_RED}Ошибка обновления через flatpak!${COLOR_RESET}"
    return 1
  fi

  return 0
}

# Вызов startFetch.sh в начале
$HOME/.config/neofetch/startFetch.sh

# Основной цикл
while true; do

  echo -e "\nПроверка доступных обновлений..."
  check_updates

  echo -e "\nНачать обновление системы?"
  read -p "Нажмите Enter для продолжения или Ctrl+C для выхода."

  if update_system; then
    echo -e "${COLOR_GREEN}\nОбновление завершено успешно!${COLOR_RESET}"
  else
    echo -e "${COLOR_RED}\nОбновление прервано!${COLOR_RESET}"
  fi

  echo -e "\nНажмите Enter для завершения."
  read

  clear
  # Вызов startFetch.sh в конце
  $HOME/.config/neofetch/startFetch.sh

  figlet -f mini "' -->  bye  <-- '"
  figlet -f mini "' -->  bye  <-- '"
  figlet -f mini "' -->  maaru ^^  <-- '"

  sleep 5
  break
done
