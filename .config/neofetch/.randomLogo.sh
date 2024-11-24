#!/bin/bash

# Путь к директории с логотипами
LOGO_DIR="$HOME/.config/neofetch/.pngs"

# Путь к файлу кэша
CACHE_FILE="$HOME/.config/neofetch/.logo_cache.txt"

# Массив логотипов (автоматическое добавление всех .png файлов из LOGO_DIR)
LOGOS=()
for logo in "$LOGO_DIR"/*.png; do
    LOGOS+=("$logo")
done

# Выбрать случайный логотип
RANDOM_LOGO="${LOGOS[$RANDOM % ${#LOGOS[@]}]}"

# Записать путь к выбранному логотипу в файл кэша
echo "$RANDOM_LOGO" > "$CACHE_FILE"

echo "Updated logo cache to: $RANDOM_LOGO"

