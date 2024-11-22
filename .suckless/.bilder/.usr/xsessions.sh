#!/bin/bash

# Местоположение файла dwm.desktop
dwm_desktop_src="$HOME/dwm_dots-maaru/.suckless/dwm.desktop"
dwm_desktop_dst="/usr/share/xsessions/dwm.desktop"

# Функция для проверки наличия файла в каталоге /usr/share/xsessions/
check_dwm_desktop() {
    if [ -f "$dwm_desktop_dst" ]; then
        echo "Файл dwm.desktop уже существует в $dwm_desktop_dst."
        return 0
    else
        echo "Файл dwm.desktop не найден в $dwm_desktop_dst."
        return 1
    fi
}

# Проверяем наличие каталога xsessions
if [ -d "/usr/share/xsessions" ]; then
    echo "Директория /usr/share/xsessions существует."
else
    echo "Директория /usr/share/xsessions не существует!"
    exit 1
fi

# Проверка наличия файла dwm.desktop
if check_dwm_desktop; then
    # Запрос на перезапись файла
    read -p "Вы хотите перезаписать файл dwm.desktop? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Перезаписываем файл dwm.desktop..."
        sudo cp "$dwm_desktop_src" "$dwm_desktop_dst"
        if [ $? -eq 0 ]; then
            echo "Файл dwm.desktop успешно перезаписан в /usr/share/xsessions."
        else
            echo "Ошибка при перезаписи файла dwm.desktop."
            exit 1
        fi
    else
        echo "Операция отменена. Файл не был перезаписан."
        exit 0
    fi
else
    # Проверка на наличие исходного файла
    if [ -f "$dwm_desktop_src" ]; then
        echo "Копируем dwm.desktop в /usr/share/xsessions..."
        sudo cp "$dwm_desktop_src" "$dwm_desktop_dst"
        if [ $? -eq 0 ]; then
            echo "Файл dwm.desktop успешно добавлен в /usr/share/xsessions."
        else
            echo "Ошибка при копировании файла dwm.desktop."
            exit 1
        fi
    else
        echo "Исходный файл $dwm_desktop_src не найден!"
        exit 1
    fi
fi

echo " "
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "dwm.desktop добавлен в xsessions!"
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

