#!/bin/bash

# Переменная для домашней директории
HOME_DIR=$HOME
SOURCE_DIR="$HOME/dwm_dots-maaru"

# Цвета для оформления
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
COLOR_CYAN="\033[36m"

# Массив файлов для копирования
FILES_TO_COPY=(
    "wallpapers"
    ".current_wallpaper"
    ".Xauthority"
    ".xinitrc"
    ".Xresources"
    ".xsession"
    ".icons"
    ".suckless"
    ".themes"
    "Images"
    "Videos"
)

# Функция создания резервной копии
create_backup() {
    local file=$1
    local backup="${file}_backup_$(date +%Y%m%d%H%M%S)"
    echo -e "${COLOR_YELLOW}Создаю резервную копию: $file -> $backup${COLOR_RESET}"
    cp -r "$file" "$backup"
}

# Функция копирования файлов с проверками
copy_file() {
    local source="$SOURCE_DIR/$1"
    local destination="$HOME_DIR/$1"

    # Проверяем существование источника
    if [ ! -e "$source" ]; then
        echo -e "${COLOR_RED}Ошибка: $source не существует!${COLOR_RESET}"
        return 1
    fi

    # Проверяем, существует ли целевой файл/каталог
    if [ -e "$destination" ]; then
        echo -e "${COLOR_YELLOW}Внимание: $destination уже существует.${COLOR_RESET}"
        read -p "$(echo -e "${COLOR_CYAN}Создать резервную копию и перезаписать? (y/n): ${COLOR_RESET}")" choice
        if [[ "$choice" =~ ^[yY]$ ]]; then
            create_backup "$destination"
            cp -r "$source" "$destination"
            echo -e "${COLOR_GREEN}Скопировано (с резервной копией): $source -> $destination${COLOR_RESET}"
        else
            echo -e "${COLOR_YELLOW}Пропущено: $destination${COLOR_RESET}"
        fi
    else
        cp -r "$source" "$destination"
        echo -e "${COLOR_GREEN}Скопировано: $source -> $destination${COLOR_RESET}"
    fi
}

# Флаг успешности
success=true

# Копирование всех файлов
for file in "${FILES_TO_COPY[@]}"; do
    copy_file "$file" || success=false
done

# Финальное сообщение
if $success; then
    echo -e "\n${COLOR_GREEN}
     ██████╗  ██████╗  ██████╗ ██████╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗
    ██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
    ██║  ███╗██║   ██║██║   ██║██║  ██║    ██║     ██║   ██║██████╔╝ ╚████╔╝ 
    ██║   ██║██║   ██║██║   ██║██║  ██║    ██║     ██║   ██║██╔═══╝   ╚██╔╝  
    ╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝    ╚██████╗╚██████╔╝██║        ██║   
     ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝        ╚═╝   
    ${COLOR_RESET}"
else
    echo -e "\n${COLOR_RED}Копирование завершено с ошибками. Проверьте вышеуказанные сообщения.${COLOR_RESET}"
fi
sleep 1
