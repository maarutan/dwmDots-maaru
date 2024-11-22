#!/bin/bash

# Объявление переменных
REPO_SSH=${REPO_SSH:-"git@github.com:maarutan/dwm-maaru.git"}

BRANCH=${BRANCH:-"main"}
SOURCE_DIR=${SOURCE_DIR:-"$HOME/.dwm-maaru-sync"}
TARGET_DIR=${TARGET_DIR:-"$HOME/.dwm-maaru"}

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

# Функция для анимации загрузки с индикатором прогресса
loading_animation() {
    echo -n "["
    for i in {1..10}; do
        echo -n "="
        sleep 0.2
    done
    echo "]"
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

# Определение ASCII-арта
ascii_arts=(
    "$(cat << 'EOF'
  _          _   _     _          _
 (_)  _ _   (_) | |_  (_)  __ _  | |
 | | | ' \  | | |  _| | | / _` | | |
 |_| |_||_| |_|  \__| |_| \__,_| |_|
EOF
)"
    "$(cat << 'EOF'
          _ _   
     __ _(_) |_ 
 _  / _` | |  _|
(_) \__, |_|\__|
    |___/       
EOF
)"
    "$(cat << 'EOF'
                    _ _   
 __ ___ _ __  _ __ (_) |_ 
/ _/ _ \ '  \| '  \| |  _|
\__\___/_|_|_|_|_|_|_|\__|
EOF
)"
    "$(cat << 'EOF'
              _    
 _ __ _  _ __| |_  
| '_ \ || (_-< ' \ 
| .__/\_,_/__/_||_|
|_|           
EOF
)"
)

# Шаг 1: Очистка экрана, запуск neofetch, вывод ASCII-арта и проверка наличия репозитория
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "${ascii_arts[0]}"
sleep 1.3

# Проверка наличия .git в целевой директории
if [ -d "$TARGET_DIR/.git" ]; then
    clear
    if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
        $HOME/.config/neofetch/startFetch.sh
    else
        neofetch
    fi
    display_ascii_art "${ascii_arts[1]}"
    echo "Репозиторий уже клонирован. Обновляем его..."
    cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }
    git pull origin "$BRANCH"
    git checkout HEAD .
else
    clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "$(cat << 'EOF'
  _   _      ___   _                    
 __ _  (_) | |_   / __| | |  ___   _ _    ___ 
/ _` | | | |  _| | (__  | | / _ \ | ' \  / -_)
\__, | |_|  \__|  \___| |_| \___/ |_||_| \___|
|___/
EOF
)"
sleep 1.3
sleep 1.3
    echo "Репозиторий не найден. Клонируем его..."
    git clone --branch "$BRANCH" "$REPO_SSH" "$TARGET_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка при клонировании репозитория"
        exit 1
    fi
fi

# Шаг 3: Копирование символьных ссылок и файлов
clear
sl
rsync -a --copy-links --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/" --ignore-errors >/dev/null 2>&1

# Шаг 4: Добавление файлов в Git
cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }
git add .
if [ $? -ne 0 ]; then
    echo "Ошибка при добавлении файлов в Git"
    exit 1
fi

# Очистка экрана, запуск neofetch, вывод ASCII-арта перед коммитом
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "${ascii_arts[2]}"
echo "Введите сообщение для коммита (по умолчанию: 'add'):"
read -t 10 COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-add}
git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "Ошибка при создании коммита"
    exit 1
fi

# Очистка экрана, запуск neofetch и вывод ASCII-арта перед пушем
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "${ascii_arts[3]}"
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
read -t 5 -r DELETE_TEMP
DELETE_TEMP=${DELETE_TEMP:-n}
if [[ "$DELETE_TEMP" == "y" ]]; then
    rm -rf "$TARGET_DIR"
    echo "Временная директория удалена."
else
    echo "Временная директория сохранена."
fi
