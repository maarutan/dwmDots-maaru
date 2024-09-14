#!/bin/bash

# Пути к иконкам
ICON_PACMAN="$HOME/.icons/pacman.svg"
ICON_PARU="$HOME/.icons/Paruyay.svg"
ICON_FLATPAK="$HOME/.icons/flatpak.png"
ICON_SUCCESS="$HOME/.icons/success.svg"
ICON_ERROR="$HOME/.icons/error.svg"

# Цвета для вывода текста
COLOR_YELLOW='\033[1;33m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_RED='\033[0;31m'
COLOR_RESET='\033[0m'

# Функция обновления
update_system() {
    echo -e "${COLOR_YELLOW}\n=== Обновление pacman ===${COLOR_RESET}"
    if ! sudo pacman -Syu --noconfirm; then
        echo -e "${COLOR_RED}Ошибка обновления через pacman!${COLOR_RESET}"
        return 1
    fi

    echo -e "${COLOR_GREEN}\n=== Обновление paru ===${COLOR_RESET}"
    if ! paru -Syu --noconfirm; then
        echo -e "${COLOR_RED}Ошибка обновления через paru!${COLOR_RESET}"
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

/home/maaru/.config/neofetch/startFetch.sh
# Основной цикл
while true; do

    echo -e "\nДоступные обновления:"

    # Проверка обновлений для pacman
    pacman_updates=$(pacman -Qu)
    if [ -n "$pacman_updates" ]; then
        echo -e "${COLOR_YELLOW}  ===> pacman -----> 󰮯 :"
        echo "$pacman_updates" | awk '{print "       " $1}'
    else
        echo -e "${COLOR_YELLOW}  ===> pacman -----> нет обновлений${COLOR_RESET}"
    fi

    # Проверка обновлений для paru
    paru_updates=$(paru -Qu)
    if [ -n "$paru_updates" ]; then
        echo -e "${COLOR_GREEN}  ===> paru -------> 󰣇 :"
        echo "$paru_updates" | awk '{print "       " $1}'
    else
        echo -e "${COLOR_GREEN}  ===> paru -------> нет обновлений${COLOR_RESET}"
    fi

    # Проверка обновлений для flatpak
    flatpak_updates=$(flatpak remote-ls --updates)
    if [ -n "$flatpak_updates" ]; then
        echo -e "${COLOR_CYAN}  ===> flatpak ---->  :"
        echo "$flatpak_updates" | awk '{print "       " $1}'
    else
        echo -e "${COLOR_CYAN}  ===> flatpak ----> нет обновлений${COLOR_RESET}"
    fi

    echo -e "\nНачало обновления системы..."

    read -p "Нажмите Enter для продолжения или Ctrl+C для выхода."

    if update_system; then
        echo -e "${COLOR_GREEN}\nОбновление завершено успешно!${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}\nОбновление прервано!${COLOR_RESET}"
    fi

    echo -e "\nНажмите Enter для завершения."
    read

    clear
    # Вызов startFetch.sh в конце, перед figlet
    /home/maaru/.config/neofetch/startFetch.sh

    figlet -f mini "' -->  bye  <-- '"
    echo "' -->  bye  <-- '"
    echo "' -->  maaru ^^  <-- '"

    sleep 5
    break
done

