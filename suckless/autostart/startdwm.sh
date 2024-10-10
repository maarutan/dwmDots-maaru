#!/bin/bash
echo "Настройка курсора..."
xsettingsd &

#echo "Запуск композитора..."
#picom &

echo "Запуск свайпов для таспада"
pkill -f libinput-gestures
libinput-gestures-setup start &

echo "Настройка раскладки клавиатуры..."
setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'

echo "Запуск уведомлений..."
dunst &

sleep 0.5
echo "Установка фонового изображения..."
if [ -f ~/.current_wallpaper ]; then
  feh --bg-scale "$(head -n 1 ~/.current_wallpaper)"
else
  echo "Файл ~/.current_wallpaper не найден."
fi

#echo "mechvibes"
#$HOME/suckless/scripts/keyvolume.sh

echo "Запуск строки состояния..."
dwmblocks &
$HOME/suckless/scripts/dwmbScripts/blocks.sh &

while true; do
  dwm 2>~/.dwm.log
done
