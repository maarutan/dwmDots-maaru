#!/bin/bash

# Путь к файлу currentwallpaper
FILE="$HOME/.current_wallpaper"

# Путь к папке с обоями
WALLPAPERS_DIR="$HOME/wallpapers"

# Проверяем, существует ли файл currentwallpaper
if [ ! -f "$FILE" ]; then
    echo "Файл '$FILE' не найден. Создаю новый и выбираю один из обоев."
    
    # Проверяем, существует ли файл bg-49.png
    if [ -f "$WALLPAPERS_DIR/bg-49.png" ]; then
        wallpaper="$WALLPAPERS_DIR/bg-49.png"
        echo "$wallpaper" > "$FILE"
        echo "Записан путь к изображению: $wallpaper"
    # Если bg-49.png нет, проверяем bg-49.jpg
    elif [ -f "$WALLPAPERS_DIR/bg-49.jpg" ]; then
        wallpaper="$WALLPAPERS_DIR/bg-49.jpg"
        echo "$wallpaper" > "$FILE"
        echo "Записан путь к изображению: $wallpaper"
    else
        # Если нет ни того, ни другого, выбираем случайный файл из папки wallpapers
        wallpaper=$(ls $WALLPAPERS_DIR/*.{jpg,png} | shuf -n 1)
        echo "$wallpaper" > "$FILE"
        echo "Записан случайный путь к изображению: $wallpaper"
    fi
else
    # Если файл существует, проверяем, что в нем только одна строка
    line_count=$(wc -l < "$FILE")
    
    if [ "$line_count" -gt 1 ]; then
        echo "В файле '$FILE' больше одной строки. Ожидается только один путь к изображению."

        # Очищаем файл и выбираем один путь
        if [ -f "$WALLPAPERS_DIR/bg-49.png" ]; then
            wallpaper="$WALLPAPERS_DIR/bg-49.png"
            echo "$wallpaper" > "$FILE"
            echo "Перезаписан файл. Записан новый путь к изображению: $wallpaper"
        elif [ -f "$WALLPAPERS_DIR/bg-49.jpg" ]; then
            wallpaper="$WALLPAPERS_DIR/bg-49.jpg"
            echo "$wallpaper" > "$FILE"
            echo "Перезаписан файл. Записан новый путь к изображению: $wallpaper"
        else
            wallpaper=$(ls $WALLPAPERS_DIR/*.{jpg,png} | shuf -n 1)
            echo "$wallpaper" > "$FILE"
            echo "Перезаписан файл. Записан случайный путь к изображению: $wallpaper"
        fi
    else
        # Если в файле одна строка, проверяем, существует ли файл изображения
        current_wallpaper=$(cat "$FILE")
        
        if [ ! -f "$current_wallpaper" ]; then
            echo "Файл изображения '$current_wallpaper' не найден. Выбираю новый файл."

            # Проверяем, существует ли файл bg-49.png
            if [ -f "$WALLPAPERS_DIR/bg-49.png" ]; then
                wallpaper="$WALLPAPERS_DIR/bg-49.png"
                echo "$wallpaper" > "$FILE"
                echo "Записан новый путь к изображению: $wallpaper"
            # Если bg-49.png нет, проверяем bg-49.jpg
            elif [ -f "$WALLPAPERS_DIR/bg-49.jpg" ]; then
                wallpaper="$WALLPAPERS_DIR/bg-49.jpg"
                echo "$wallpaper" > "$FILE"
                echo "Записан новый путь к изображению: $wallpaper"
            else
                # Если нет ни того, ни другого, выбираем случайный файл из папки wallpapers
                wallpaper=$(ls $WALLPAPERS_DIR/*.{jpg,png} | shuf -n 1)
                echo "$wallpaper" > "$FILE"
                echo "Записан случайный путь к изображению: $wallpaper"
            fi
        else
            echo "Путь в файле '$FILE' валиден: '$current_wallpaper'."
        fi
    fi
fi

# Применяем изображение как обои с помощью feh
feh --bg-scale "$(cat "$FILE")"
echo "Обои установлены: $(cat "$FILE")"

