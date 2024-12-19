#!/bin/env bash

# Директория темы и файл темы
dir="$HOME/.config/rofi/powermenu"
theme='config'

# Проверка существования скрипта блокировки экрана
lock_script="$HOME/.config/rofi/powermenu/.screen-lock.sh"
if [ ! -x "$lock_script" ]; then
    echo "Lock script not found or not executable."
    lock_script=""
fi

# Опции меню
options="    Lock\n 󰩈   Logout\n 󰒲   Suspend\n    Reboot\n    Shutdown"

# Показываем меню и сохраняем выбор
choice=$(printf "$options" | rofi -dmenu -theme "${dir}/${theme}.rasi" -p "System Menu:")

# Выполняем действие на основе выбора
case "$choice" in
  "Lock")
    [ -n "$lock_script" ] && sh "$lock_script" || echo "Lock script not found." ;;
  "Logout")
    pkill -KILL -u "$USER" || echo "Failed to logout." ;;
  "Suspend")
    systemctl suspend && [ -n "$lock_script" ] && sh "$lock_script" || echo "Failed to suspend or lock." ;;
  "Reboot")
    systemctl reboot || echo "Failed to reboot." ;;
  "Shutdown")
    systemctl poweroff || echo "Failed to shutdown." ;;
  *)
    echo "No valid choice selected." ;;
esac
