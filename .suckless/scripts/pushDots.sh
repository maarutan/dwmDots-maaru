#!/bin/bash

# Объявление переменных
REPO_SSH=${REPO_SSH:-"git@github.com:maarutan/dwmDots-maaru.git"}
BRANCH=${BRANCH:-"main"}
SOURCE_DIR=${SOURCE_DIR:-"$HOME/.dwm_sync-maaru"}
TARGET_DIR=${TARGET_DIR:-"$HOME/.dwm_dots-maaru"}

# //==============доп вызовы==============//
YOURTERM=${YOURTERM:-"kitty -e"}
add_more_push()
{
    $HOME/.suckless/scripts/pushVSconfig.sh 
    $HOME/.suckless/scripts/pushdwm.sh 
}
# //==============доп вызовы==============//

# Проверка наличия необходимых приложений
required_apps=(git rsync neofetch bc figlet sl)
missing_apps=()

for app in "${required_apps[@]}"; do
    if ! command -v $app &> /dev/null; then
        missing_apps+=($app)
    fi
done
if [ ${#missing_apps[@]} -ne 0 ]; then
    echo "Ошибка: Для корректной работы скрипта необходимо установить следующие приложения: ${missing_apps[*]}"
    exit 1
fi

# Функция для установки цвета текста
color() {
    echo -e "\033[$1m$2\033[0m"
}

# Функция для создания радужного текста
rainbow_text() {
    local text="$1"
    local colors=(31 32 33 34 35 36)  # Красный, зелёный, жёлтый, синий, фиолетовый, голубой
    local colored_text=""

    for ((i=0; i<${#text}; i++)); do
        char="${text:$i:1}"
        color_index=$((i % ${#colors[@]}))
        colored_text+=$(color "${colors[$color_index]}" "$char")
    done

    echo -e "$colored_text"
}

# Функция для вывода ASCII-арта с радужным текстом
display_ascii_art() {
    local ascii_art="$1"
    while IFS= read -r line; do
        rainbow_text "$line"
    done <<< "$ascii_art"
}

# Функция для удаления дубликатов
remove_duplicates() {
    local dir="$1"
    local duplicates_found=false

    # Проходим по всем поддиректориям
    find "$dir" -type d | while read -r subdir; do
        parent_dir=$(dirname "$subdir")
        duplicate_dir="$parent_dir/$(basename "$subdir")"

        # Если родительская папка содержит папку с таким же именем
        if [ "$subdir" != "$duplicate_dir" ] && [ -d "$duplicate_dir" ]; then
            # Проверяем, является ли содержимое папок идентичным
            if diff -rq "$subdir" "$duplicate_dir" >/dev/null 2>&1; then
                echo "Найдена копия: $duplicate_dir, удаляем..."
                rm -rf "$duplicate_dir"
                duplicates_found=true
            fi
        fi
    done

    if [ "$duplicates_found" = true ]; then
        echo "Дубликаты успешно удалены."
    else
        echo "Дубликатов не обнаружено."
    fi
}

# Функция для обработки выхода из скрипта
trap_exit() {
    clear
    ascii_art_exit=$(figlet -f small "bye bye $USER ^^")
    display_ascii_art "$ascii_art_exit"
    sleep 1.3
    exit 0
}

# Установка обработчика прерывания
trap trap_exit SIGINT

# ASCII-арт
ascii_arts=(
    "$(cat << 'EOF'
  _          _   _     _          _
 (_)  _ _   (_) | |_  (_)  __ _  | |
 | | | ' \  | | |  _| | | / _` | | |
 |_| |_||_| |_|  \__| |_| \__,_| |_|
EOF
)"
)

# Очистка экрана, запуск neofetch и вывод ASCII-арта
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "${ascii_arts[0]}"
sleep 1.3

# Проверка наличия репозитория
if [ -d "$TARGET_DIR/.git" ]; then
    echo "Репозиторий уже клонирован. Обновляем его..."
    cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }
    git pull origin "$BRANCH"
    git checkout HEAD .
else
    echo "Репозиторий не найден. Клонируем его..."
    git clone --branch "$BRANCH" "$REPO_SSH" "$TARGET_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка при клонировании репозитория"
        exit 1
    fi
fi

# Копирование файлов и проверка дубликатов
rsync -a --copy-links --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/" --ignore-errors
remove_duplicates "$TARGET_DIR"

# Добавление файлов в Git
cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }
git add .
echo "Введите сообщение для коммита (по умолчанию: 'add'):"
read -t 10 COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-add}
git commit -m "$COMMIT_MSG"

# Пуш в репозиторий
git push origin "$BRANCH"

