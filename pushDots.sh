#!/bin/bash

# Функция для установки цвета текста
color() {
    echo -e "\033[$1m$2\033[0m"
}

# Функция для создания радужного текста
rainbow_text() {
    local text="$1"
    local colors=(31 32 33 34 35 36)  # Красный, зелёный, жёлтый, синий, фиолетовый, голубой
    local colored_text=""

    # Итерация по каждой букве текста
    for ((i=0; i<${#text}; i++)); do
        char="${text:$i:1}"
        color_index=$((i % ${#colors[@]}))  # Определяем цвет по индексу
        colored_text+=$(color "${colors[$color_index]}" "$char")
    done

    echo -e "$colored_text"
}

# ASCII арт
ascii_art=$(cat << 'EOF'
  ___ _ _      ___ _          _           
 / __(_) |_   / __| |___ _ _ (_)_ _  __ _ 
| (_ | |  _| | (__| / _ \ ' \| | ' \/ _` |
 \___|_|\__|  \___|_\___/_||_|_|_||_\__, |
                                    |___/ 
EOF
)

# Шаг 1: Вывод радужного ASCII-арта
while IFS= read -r line; do
    rainbow_text "$line"
done <<< "$ascii_art"

# Шаг 2: Объявление переменных
REPO_SSH="git@github.com:maarutan/dwmDots-maaru.git"  # Ссылка на репозиторий
BRANCH="main"  # Ветка для пуша
SOURCE_DIR="$HOME/.dwmSync-maaru"  # Рабочая директория с файлами
TEMP_DIR="/tmp/dotfiles_sync"  # Временная директория для пуша

# Шаг 2: Создание временной папки и клонирование репозитория
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Клонируем репозиторий в временную директорию
git clone --branch "$BRANCH" "$REPO_SSH" "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Ошибка при клонировании репозитория"
    exit 1
fi

# Удаляем все, кроме .git
rm -rf "$TEMP_DIR"/*  # Удаляем все содержимое
mv "$TEMP_DIR/.git" "$TEMP_DIR/.git_temp"  # Временно перемещаем .git
rm -rf "$TEMP_DIR"/*  # Удаляем все
mv "$TEMP_DIR/.git_temp" "$TEMP_DIR/.git"  # Возвращаем .git обратно

# Шаг 3: Копирование символьных ссылок и файлов
# Используем rsync для копирования, преобразуя символьные ссылки в обычные файлы
rsync -a --copy-links --exclude='.git' "$SOURCE_DIR/" "$TEMP_DIR/" --ignore-errors

# Шаг 4: Добавление файлов в Git, коммит и пуш
cd "$TEMP_DIR" || { echo "Не удалось перейти в директорию $TEMP_DIR"; exit 1; }
git add .
if [ $? -ne 0 ]; then
    echo "Ошибка при добавлении файлов в Git"
    exit 1
fi

echo "Введите сообщение для коммита (по умолчанию: 'add'):"
read -t 10 COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-add}
git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "Ошибка при создании коммита"
    exit 1
fi

git push origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "Ошибка при пуше. Попробовать снова? (y/n)"
    read -r RETRY
    if [[ "$RETRY" == "y" ]]; then
        "$0"  # Повторный запуск текущего скрипта
    else
        exit 1
    fi
fi

# Шаг 6: Удаление временной директории
echo "Удалить временную директорию? (y/n)"
read -r DELETE_TEMP
if [[ "$DELETE_TEMP" == "y" ]] || [[ -z "$DELETE_TEMP" ]]; then
    rm -rf "$TEMP_DIR"
    echo "Временная директория удалена."
else
    echo "Временная директория сохранена."
fi

