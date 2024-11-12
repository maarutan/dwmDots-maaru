#!/bin/bash

# Объявление переменных
REPO_SSH=${REPO_SSH:-"git@github.com:maarutan/dwmDots-maaru.git"}
BRANCH=${BRANCH:-"main"}
SOURCE_DIR=${SOURCE_DIR:-"$HOME/.dwmSync-maaru"}
TARGET_DIR=${TARGET_DIR:-"$HOME/.dwmDots-maaru"}

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

# Функция для вывода ASCII-арта с радужным текстом
display_ascii_art() {
    local ascii_art="$1"
    while IFS= read -r line; do
        rainbow_text "$line"
    done <<< "$ascii_art"
}

# ASCII арт 1
ascii_art_1=$(cat << 'EOF'
  ___ _ _      ___ _          _           
 / __(_) |_   / __| |___ _ _ (_)_ _  __ _ 
| (_ | |  _| | (__| / _ \ ' \| | ' \/ _` |
 \___|_|\__|  \___|_\___/_||_|_|_||_\__, |
                                    |___/ 
EOF
)

# ASCII арт 2
ascii_art_2=$(cat << 'EOF'
                    _ _   
 __ ___ _ __  _ __ (_) |_ 
/ _/ _ \ '  \| '  \| |  _|
\__\___/_|_|_|_|_|_|_|\__|
EOF
)

# ASCII арт 3
ascii_art_3=$(cat << 'EOF'
              _    
 _ __ _  _ __| |_  
| '_ \ || (_-< ' \ 
| .__/\_,_/__/_||_|
|_|           
EOF
)

# ASCII арт 4 (если .git существует)
ascii_art_git_exists=$(cat << 'EOF'
          _ _   
     __ _(_) |_ 
 _  / _` | |  _|
(_) \__, |_|\__|
    |___/       
EOF
)

# Шаг 1: Очистка экрана и запуск neofetch перед выводом ASCII-арта
clear
$HOME/.config/neofetch/startFetch.sh

# Проверка наличия .git в целевой директории
if [ -d "$TARGET_DIR/.git" ]; then
    display_ascii_art "$ascii_art_git_exists"
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

# Шаг 3: Копирование символьных ссылок и файлов
# Используем rsync для копирования, преобразуя символьные ссылки в обычные файлы
rsync -a --copy-links --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/" --ignore-errors

# Шаг 4: Добавление файлов в Git, коммит и пуш
cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }

# Очистка экрана и запуск neofetch перед добавлением файлов
clear
$HOME/.config/neofetch/startFetch.sh
git add .
if [ $? -ne 0 ]; then
    echo "Ошибка при добавлении файлов в Git"
    exit 1
fi

# Очистка экрана и запуск neofetch перед выводом второго ASCII-арта
clear
$HOME/.config/neofetch/startFetch.sh
display_ascii_art "$ascii_art_2"

# Очистка экрана и запуск neofetch перед коммитом
clear
$HOME/.config/neofetch/startFetch.sh
echo "Введите сообщение для коммита (по умолчанию: 'add'):"
read -t 10 COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-add}
git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "Ошибка при создании коммита"
    exit 1
fi

# Очистка экрана и запуск neofetch перед выводом третьего ASCII-арта
clear
$HOME/.config/neofetch/startFetch.sh
display_ascii_art "$ascii_art_3"

# Очистка экрана и запуск neofetch перед пушем
clear
$HOME/.config/neofetch/startFetch.sh
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
echo "Удалить временную директорию? (y/n) (по умолчанию: 'n')"
read -r DELETE_TEMP
if [[ "$DELETE_TEMP" == "y" ]]; then
    rm -rf "$TARGET_DIR"
    echo "Временная директория удалена."
else
    echo "Временная директория сохранена."
fi

