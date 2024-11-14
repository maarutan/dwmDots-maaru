#!/bin/bash

# Настройка qt5
export QT_QPA_PLATFORMTHEME=qt5ct

# Настройка курсора с помощью xsettingsd
xsettingsd &

# Запуск композитора для управления окнами
picom &

# Остановка предыдущих процессов libinput-gestures и их перезапуск
pkill -f libinput-gestures
libinput-gestures-setup start &

# Настройка раскладки клавиатуры: переключение между us и ru при помощи Ctrl + Alt
setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'

# Запуск менеджера уведомлений dunst
dunst &

# Запуск буфера обмена
greenclip daemon &

# Небольшая пауза перед установкой фонового изображения
sleep 0.5

# Установка фонового изображения из файла ~/.current_wallpaper, если он существует
if [ -f ~/.current_wallpaper ]; then
    feh --bg-scale "$(head -n 1 ~/.current_wallpaper)"
else
    # Если файл не найден, сообщаем об этом
    echo "Файл ~/.current_wallpaper не найден."
fi

# Запуск строки состояния dwmblocks и пользовательских скриптов
dwmblocks &
$HOME/suckless/scripts/dwmbScripts/blocks.sh &

# Запуск Bluetooth-апплета
blueman-applet &

# Запуск Telegram
telegram-desktop &

# Запуск Firefox
(
firefox 
xdotool key super+1
)&

# Автоматический запуск neofetch в новом терминале через 3 секунды
(
    sleep 2
    kitty --title "neofetch_terminal" -e bash -c 'neofetch --config $HOME.config/neofetch/myProfile.conf; exec bash'
    xdotool key super+1
) &

# Запуск оконного менеджера dwm в бесконечном цикле с перенаправлением ошибок в лог-файл
while true; do
    dwm 2>~/.dwm.log &
done

