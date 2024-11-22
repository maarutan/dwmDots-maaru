#!/bin/sh
cd $HOME/.suckless/dwm || { notify-send "Не удается найти директорию dwm"; exit 1; }
make clean install || { notify-send "Ошибка при перекомпиляции dwm"; exit 1; }
