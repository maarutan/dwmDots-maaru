#!/bin/bash

# Объявление переменных
REPO_SSH=${REPO_SSH:-"git@github.com:maarutan/dwmDots-maaru.git"}
BRANCH=${BRANCH:-"main"}
SOURCE_DIR=${SOURCE_DIR:-"$HOME/.dwmSync-maaru"}
TARGET_DIR=${TARGET_DIR:-"$HOME/.dwmDots-$(echo $USER)"}

# Проверка наличия необходимых приложений
required_apps=(git rsync neofetch bc figlet)
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

# Функция для анимации загрузки
loading_animation() {
    echo -n "Loading"
    for i in {1..6}; do
        echo -n "."
        sleep 0.3
    done
    echo ""
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

# Шаг 1: Очистка экрана, запуск neofetch, вывод ASCII-арта и анимация загрузки
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "$ascii_art_1"
loading_animation

# Проверка наличия .git в целевой директории
if [ -d "$TARGET_DIR/.git" ]; then
    display_ascii_art "$ascii_art_git_exists"
    echo "Репозиторий уже клонирован. Обновляем его..."
    cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }
    git pull origin "$BRANCH"
    git checkout HEAD .
else
    echo "Репозиторий не найден. Клонируем его..."
    start_time=$(date +%s)
    git clone --branch "$BRANCH" "$REPO_SSH" "$TARGET_DIR"
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    
    if [ $? -ne 0 ]; then
        echo "Ошибка при клонировании репозитория"
        exit 1
    fi
    
    if (( $(echo "$elapsed_time < 1.5" | bc -l) )); then
        loading_animation
    fi
fi

# Шаг 3: Копирование символьных ссылок и файлов
start_time=$(date +%s)
loading_animation &
LOADING_PID=$!
rsync -a --copy-links --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/" --ignore-errors >/dev/null 2>&1
kill $LOADING_PID
wait $LOADING_PID 2>/dev/null
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

if (( $(echo "$elapsed_time < 1.5" | bc -l) )); then
    loading_animation
fi

# Шаг 4: Добавление файлов в Git, коммит и пуш
cd "$TARGET_DIR" || { echo "Не удалось перейти в директорию $TARGET_DIR"; exit 1; }

# Очистка экрана, запуск neofetch, вывод ASCII-арта и анимация загрузки перед добавлением файлов
tart_time=$(date +%s)
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "$ascii_art_2"
loading_animation
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

if (( $(echo "$elapsed_time < 1.5" | bc -l) )); then
    loading_animation
fi
git add .
if [ $? -ne 0 ]; then
    echo "Ошибка при добавлении файлов в Git"
    exit 1
fi

# Очистка экрана, запуск neofetch, вывод ASCII-арта и анимация загрузки перед коммитом
start_time=$(date +%s)
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
display_ascii_art "$ascii_art_3"
loading_animation
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

if (( $(echo "$elapsed_time < 1.5" | bc -l) )); then
    loading_animation
fi
echo "Введите сообщение для коммита (по умолчанию: 'add'):"
read -t 10 COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-add}
git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "Ошибка при создании коммита"
    exit 1
fi

# Очистка экрана, запуск neofetch и анимация загрузки перед пушем
start_time=$(date +%s)
clear
if [ -f "$HOME/.config/neofetch/startFetch.sh" ]; then
    $HOME/.config/neofetch/startFetch.sh
else
    neofetch
fi
loading_animation
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

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

