#!/bin/sh

# Запуск Telegram
#XDG_CURRENT_DESKTOP=gnome telegram-desktop -startintray &

# Настройка курсора
xsettingsd &

# Запуск композитора
picom &

# Настройка раскладки клавиатуры и Caps Lock как Ctrl
setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'

# управление мышю из клавьятуры 
#warpd &

#infoupdate for dwmblocks
~/suckless/scripts/updateInfo.sh & 

# Запуск уведомлений
dunst &
# Установка фонового изображения
feh --bg-scale "$(cat ~/.current_wallpaper | head -n 1)"



#строка состояния
dwmblocks &

# Запуск dwm
while true; do
    dwm 2>~/.dwm.log
done

while true; do
	~/suckless/scripts/dwmbScripts/blocks.sh &
	sleep 1
done


