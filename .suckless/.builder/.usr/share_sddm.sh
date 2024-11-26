#!/bin/bash

# Путь к исходной директории с темой
sugar_candy_src="$HOME/dwm_dots-maaru/sddm/sugar-candy"

# Путь к целевой директории
sugar_candy_dst="/usr/share/sddm/themes/sugar-candy"

# Проверяем, существует ли исходная директория
if [ ! -d "$sugar_candy_src" ]; then
    echo "Ошибка: Директория '$sugar_candy_src' не найдена."
    exit 1
fi

# Проверяем, существует ли целевая директория
if [ -d "$sugar_candy_dst" ]; then
    # Запрашиваем у пользователя, перезаписывать ли директорию
    echo "Директория '$sugar_candy_dst' уже существует."
    read -p "Вы хотите её перезаписать? (y/n): " choice
    if [[ "$choice" != "y" ]]; then
        echo "Операция отменена. Директория не была перезаписана."
        exit 0
    else
        echo "Перезаписываем директорию '$sugar_candy_dst'..."
        sudo rm -rf "$sugar_candy_dst"  # Удаляем старую директорию
    fi
fi

# Копируем директорию в целевое место
echo "Копируем директорию '$sugar_candy_src' в '$sugar_candy_dst'..."
if sudo cp -r "$sugar_candy_src" "$sugar_candy_dst"; then
    echo "Директория успешно скопирована в '$sugar_candy_dst'."
else
    echo "Ошибка при копировании директории."
    exit 1
fi

# Проверка наличия файлов в целевой директории
if [ -f "$sugar_candy_dst/theme.conf" ]; then
    echo "Все необходимые файлы найдены в '$sugar_candy_dst'."
else
    echo "Внимание: Некоторых файлов может не хватать. Проверьте директорию '$sugar_candy_dst' вручную."
fi

echo " "
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "Тема для SDDM успешно добавлена!"
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"
