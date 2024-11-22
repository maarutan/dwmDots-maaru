#!/bin/bash
# Переменная для домашней директории
HOME_DIR=$HOME
SOURCE_DIR="$HOME/dwm_dots-maaru"

# Функция копирования файлов с проверкой на существование
copy_file() {
    local source=$1
    local destination=$2
    
    # Проверка на существование исходного файла или каталога
    if [ -e "$source" ]; then
        # Проверяем, файл это или каталог
        if [ -f "$source" ]; then
            echo "Файл найден: $source"
        elif [ -d "$source" ]; then
            echo "Каталог найден: $source"
        fi

        # Проверка, существует ли уже файл/каталог в целевой директории
        if [ -e "$destination/$(basename $source)" ]; then
            echo "Ошибка: $destination/$(basename $source) уже существует. Пропускаем копирование."
            return 0
        fi

        # Проверка на доступность для чтения исходного файла
        if [ -r "$source" ]; then
            echo "Доступен для чтения: $source"
        else
            echo "Ошибка: $source недоступен для чтения!"
            return 1
        fi

        # Проверка на доступность для записи в папку назначения
        if [ -w "$destination" ] || [ -d "$destination" ]; then
            echo "Копирование $source -> $destination"
            cp -r "$source" "$destination"
            return 0
        else
            echo "Ошибка: Нет доступа для записи в $destination!"
            return 1
        fi
    else
        echo "Ошибка: $source не существует!"
        return 1
    fi
}

# Флаг успешности
success=true

# Копирование файлов и каталогов
copy_file "$SOURCE_DIR/wallpapers" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.current_wallpaper" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.Xauthority" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.xinitrc" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.Xresources" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.xsession" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.icons" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.suckless" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/.themes" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/Images" "$HOME_DIR/" || success=false
copy_file "$SOURCE_DIR/Videos" "$HOME_DIR/" || success=false

# Уведомление о завершении только в случае успеха
if $success; then
    echo -e "\n \n 
     ██████╗  ██████╗  ██████╗ ██████╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗
    ██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
    ██║  ███╗██║   ██║██║   ██║██║  ██║    ██║     ██║   ██║██████╔╝ ╚████╔╝ 
    ██║   ██║██║   ██║██║   ██║██║  ██║    ██║     ██║   ██║██╔═══╝   ╚██╔╝  
    ╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝    ╚██████╗╚██████╔╝██║        ██║   
     ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝        ╚═╝   
    "
fi
