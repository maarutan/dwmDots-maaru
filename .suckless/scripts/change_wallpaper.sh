#!/bin/bash

# Директория с обоями
WALLPAPER_DIR="$HOME/wallpapers"

# Файл для хранения пути к текущим обоям
CURRENT_WALLPAPER_FILE="$HOME/.current_wallpaper"

# Проверяем, что директория с обоями не пуста
if [ ! "$(find "$WALLPAPER_DIR" -maxdepth 1 -type f)" ]; then
    echo "Директория с обоями пуста!"
    exit 1
fi

# Получаем текущее изображение
if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
    CURRENT_WALLPAPER=$(< "$CURRENT_WALLPAPER_FILE")
else
    # Если файл не существует, берем первое изображение из директории
    CURRENT_WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f | head -n 1)
    echo "$CURRENT_WALLPAPER" > "$CURRENT_WALLPAPER_FILE"
fi

# Проверяем, что текущее изображение существует
if [ ! -f "$CURRENT_WALLPAPER" ]; then
    echo "Текущее изображение не найдено!"
    exit 1
fi

# Получаем список всех обоев
WALLPAPER_LIST=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f))

# Находим текущий индекс
CURRENT_INDEX=-1
for i in "${!WALLPAPER_LIST[@]}"; do
    if [ "${WALLPAPER_LIST[$i]}" == "$CURRENT_WALLPAPER" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Проверяем, найден ли текущий индекс
if [ "$CURRENT_INDEX" -eq -1 ]; then
    echo "Не удалось найти текущий индекс обоев!"
    exit 1
fi

# Определяем направление и устанавливаем новый индекс
case $1 in
    right)
        NEW_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPER_LIST[@]} ))
        ;;
    left)
        NEW_INDEX=$(( (CURRENT_INDEX - 1 + ${#WALLPAPER_LIST[@]}) % ${#WALLPAPER_LIST[@]} ))
        ;;
    *)
        echo "Usage: $0 {right|left}"
        exit 1
        ;;
esac

# Получаем новый путь
NEW_WALLPAPER="${WALLPAPER_LIST[$NEW_INDEX]}"

# Проверяем, что новый путь существует
if [ ! -f "$NEW_WALLPAPER" ]; then
    echo "Новое изображение не найдено!"
    exit 1
fi

# Применяем обои с помощью feh
feh --bg-scale "$NEW_WALLPAPER"

# Сохраняем новое изображение
echo "$NEW_WALLPAPER" > "$CURRENT_WALLPAPER_FILE"

