#!/bin/bash

# Настройка qt5
export QT_QPA_PLATFORMTHEME=qt5ct

# Массив приложений для запуска
APPLICATIONS=(
    "xsettingsd"
    "picom --config \"$(cat $HOME/.config/picom/.last_config.txt)\""
    "libinput-gestures-setup start"
    "dunst"
    "greenclip daemon"
    "feh --bg-scale \"$(head -n 1 ~/.current_wallpaper)\""
    "dwmblocks"
    "$HOME/.suckless/scripts/dwmbScripts/blocks.sh"
    "$HOME/.suckless/scripts/battery-alert.sh"
    "blueman-applet"
    "telegram-desktop"
    # "plank"
    "kitty --title \"neofetch_terminal\" -e bash -c 'neofetch --config $HOME/.config/neofetch/myProfile.conf; exec bash'"
)

# Функция для завершения старых экземпляров приложения
kill_existing_instances() {
    local app_name="$1"
    echo "Завершаю старые экземпляры $app_name..."
    pkill -f "$app_name" 2>/dev/null || echo "$app_name не запущен."
}

# Функция для проверки и запуска приложения
run_application() {
    local app_command="$1"

    # Получаем имя приложения из команды (первое слово в команде)
    local app_name=$(echo "$app_command" | awk '{print $1}')
    
    # Проверяем, запущен ли уже процесс с точным именем
    if pgrep -x "$app_name" > /dev/null; then
        echo "$app_name уже запущен. Завершаю его."
        kill_existing_instances "$app_name"
    fi

    # Если приложение — feh, проверяем наличие файла
    if [[ "$app_name" == "feh" ]]; then
        if [[ ! -f ~/.current_wallpaper ]]; then
            echo "Файл ~/.current_wallpaper не найден. Пропускаю feh."
            return
        fi
    fi

    # Запускаем приложение асинхронно
    echo "Запуск $app_name..."
    eval "$app_command" &
}

# Установка раскладки клавиатуры
echo "Настройка раскладки клавиатуры..."
setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'

# Запуск приложений из массива
for app_command in "${APPLICATIONS[@]}"; do
    run_application "$app_command"
done

# Запуск оконного менеджера dwm в бесконечном цикле
echo "Запуск оконного менеджера dwm..."
while true; do
    setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'
    export PATH=$PATH:$HOME/.local/bin 
    dwm 2>~/.dwm.log 

done

