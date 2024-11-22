#!/bin/bash

# Местоположение директории, которую мы ищем
sugar_candy_src_1="$HOME/.dwm_dots-maaru/sddm/sugar-candy"
sugar_candy_src_2="$HOME/dwm_dots-maaru/sddm/sugar-candy"
sugar_candy_dst="/usr/share/sddm/themes/sugar-candy"

# Функция для поиска директории
find_directory() {
    if [ -d "$sugar_candy_src_1" ]; then
        echo "Найдена директория: $sugar_candy_src_1"
        sugar_candy_src="$sugar_candy_src_1"
        return 0
    elif [ -d "$sugar_candy_src_2" ]; then
        echo "Найдена директория: $sugar_candy_src_2"
        sugar_candy_src="$sugar_candy_src_2"
        return 0
    else
        # Полный поиск по системе
        echo "Директория не найдена в указанных местах. Выполняем поиск по системе..."
        found_dir=$(find / -type d -name "sugar-candy" 2>/dev/null | grep -m 1 "sddm/sugar-candy")
        if [ -z "$found_dir" ]; then
            echo "Директория 'sugar-candy' не найдена в системе!"
            return 1
        else
            echo "Найдена директория: $found_dir"
            sugar_candy_src="$found_dir"
            return 0
        fi
    fi
}

# Проверяем, существует ли директория в целевом месте
if [ -d "$sugar_candy_dst" ]; then
    # Запрашиваем у пользователя, перезаписывать ли директорию
    echo " "
    echo "Директория [sugar-candy] уже существует."
    read -p " Вы хотите её перезаписать? (y/n): " choice
    if [[ "$choice" != "y" ]]; then
        echo "Операция отменена. Директория не была перезаписана."
        exit 0
    else
        echo "Перезаписываем директорию $sugar_candy_dst..."
        sudo rm -rf "$sugar_candy_dst"  # Удаляем старую директорию
    fi
fi

# Ищем директорию sugar-candy
if find_directory; then
    # Копируем директорию в целевое место
    echo "Копируем директорию $sugar_candy_src в $sugar_candy_dst..."
    sudo cp -r "$sugar_candy_src" "$sugar_candy_dst"
    if [ $? -eq 0 ]; then
        echo "Директория успешно скопирована в $sugar_candy_dst."
    else
        echo "Ошибка при копировании директории."
    fi
else
    echo "Не удалось найти директорию для копирования."
    exit 1
fi

# Проверка наличия файлов в директории
if [ -d "$sugar_candy_dst" ]; then
    echo "Проверка файлов в $sugar_candy_dst..."
    if [ -f "$sugar_candy_dst/theme.conf" ]; then
        echo "Все необходимые файлы уже существуют."
    else
        echo "Некоторые файлы отсутствуют. Проверьте директорию вручную."
    fi
else
    echo "Ошибка: Директория $sugar_candy_dst не существует."
    exit 1
fi

echo " "
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "Тема для sddm добавлена!"
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"


