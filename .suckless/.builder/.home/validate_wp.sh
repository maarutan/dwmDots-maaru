#!/bin/bash

# Путь к файлу currentwallpaper
FILE="$HOME/.current_wallpaper"

# Путь к папке с обоями
WALLPAPERS_DIR="$HOME/wallpapers"

# Проверяем наличие feh
if ! command -v feh >/dev/null 2>&1; then
    echo "Ошибка: feh не установлен. Установите его перед запуском этого скрипта."
    exit 1
fi

# Проверяем, существует ли папка с обоями
if [ ! -d "$WALLPAPERS_DIR" ] || [ -z "$(ls -A "$WALLPAPERS_DIR")" ]; then
    echo "Ошибка: Папка '$WALLPAPERS_DIR' не существует или пуста."
    exit 1
fi

# Функция для выбора изображения
choose_wallpaper() {
    local preferred_images=("bg-49.png" "bg-49.jpg")
    for image in "${preferred_images[@]}"; do
        if [ -f "$WALLPAPERS_DIR/$image" ]; then
            echo "$WALLPAPERS_DIR/$image"
            return
        fi
    done
    # Если предпочтительных изображений нет, выбираем случайное
    ls "$WALLPAPERS_DIR"/*.{jpg,png} 2>/dev/null | shuf -n 1
}

# Проверяем, существует ли файл currentwallpaper
if [ ! -f "$FILE" ]; then
    echo "Файл '$FILE' не найден. Создаю новый."
    wallpaper=$(choose_wallpaper)
    echo "$wallpaper" > "$FILE"
    echo "Записан путь к изображению: $wallpaper"
else
    # Проверяем содержимое файла
    line_count=$(wc -l < "$FILE")
    if [ "$line_count" -ne 1 ]; then
        echo "Ошибка: В файле '$FILE' больше одной строки. Перезаписываю файл."
        wallpaper=$(choose_wallpaper)
        echo "$wallpaper" > "$FILE"
        echo "Записан новый путь к изображению: $wallpaper"
    else
        current_wallpaper=$(cat "$FILE")
        if [ ! -f "$current_wallpaper" ]; then
            echo "Файл изображения '$current_wallpaper' не найден. Выбираю новый."
            wallpaper=$(choose_wallpaper)
            echo "$wallpaper" > "$FILE"
            echo "Записан новый путь к изображению: $wallpaper"
        else
            echo "Путь в файле '$FILE' валиден: '$current_wallpaper'."
        fi
    fi
fi

# Устанавливаем обои с помощью feh
feh --bg-scale "$(cat "$FILE")"
echo "Обои установлены: $(cat "$FILE")"
