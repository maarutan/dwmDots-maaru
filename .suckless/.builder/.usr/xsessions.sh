#!/bin/bash

# Путь к исходному файлу dwm.desktop
dwm_desktop_src="$HOME/dwm_dots-maaru/.suckless/dwm.desktop"

# Путь к системной директории xsessions
dwm_desktop_dst_system="/usr/share/xsessions/dwm.desktop"

# Путь к пользовательской директории .xsessions
xsessions_dir="$HOME/.xsessions"
dwm_desktop_dst_user="$xsessions_dir/dwm.desktop"

# Проверяем, существует ли исходный файл dwm.desktop
if [ ! -f "$dwm_desktop_src" ]; then
    echo "Ошибка: Исходный файл $dwm_desktop_src не найден!"
    exit 1
fi

# Проверяем наличие системной директории /usr/share/xsessions
if [ ! -d "/usr/share/xsessions" ]; then
    echo "Директория /usr/share/xsessions не существует. Создаю..."
    sudo mkdir -p "/usr/share/xsessions"
    echo "Директория /usr/share/xsessions создана."
else
    echo "Директория /usr/share/xsessions уже существует."
fi

# Проверяем наличие пользовательской директории ~/.xsessions
if [ ! -d "$xsessions_dir" ]; then
    echo "Директория ~/.xsessions не существует. Создаю..."
    mkdir -p "$xsessions_dir"
    echo "Директория ~/.xsessions создана."
else
    echo "Директория ~/.xsessions уже существует."
fi

# Проверяем наличие файла dwm.desktop в пользовательской директории
if [ -f "$dwm_desktop_dst_user" ]; then
    echo "Файл dwm.desktop уже существует в $xsessions_dir."
    read -p "Вы хотите перезаписать его? (y/n): " choice_user
    if [[ "$choice_user" =~ ^[yY]$ ]]; then
        echo "Перезаписываем файл dwm.desktop в ~/.xsessions..."
        cp "$dwm_desktop_src" "$dwm_desktop_dst_user"
        echo "Файл dwm.desktop успешно перезаписан в ~/.xsessions."
    else
        echo "Операция отменена. Файл в ~/.xsessions не был перезаписан."
    fi
else
    echo "Копируем dwm.desktop в ~/.xsessions..."
    cp "$dwm_desktop_src" "$dwm_desktop_dst_user"
    echo "Файл dwm.desktop успешно добавлен в ~/.xsessions."
fi

# Проверяем наличие файла dwm.desktop в системной директории
if [ -f "$dwm_desktop_dst_system" ]; then
    echo "Файл dwm.desktop уже существует в /usr/share/xsessions."
    read -p "Вы хотите перезаписать его? (y/n): " choice_system
    if [[ "$choice_system" =~ ^[yY]$ ]]; then
        echo "Перезаписываем файл dwm.desktop в /usr/share/xsessions..."
        sudo cp "$dwm_desktop_src" "$dwm_desktop_dst_system"
        echo "Файл dwm.desktop успешно перезаписан в /usr/share/xsessions."
    else
        echo "Операция отменена. Файл в /usr/share/xsessions не был перезаписан."
    fi
else
    echo "Копируем dwm.desktop в /usr/share/xsessions..."
    sudo cp "$dwm_desktop_src" "$dwm_desktop_dst_system"
    echo "Файл dwm.desktop успешно добавлен в /usr/share/xsessions."
fi

echo " "
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo "dwm.desktop успешно обработан!"
echo "Проверьте ~/.xsessions и /usr/share/xsessions."
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

