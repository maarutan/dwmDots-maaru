#!/bin/bash

# Интервал обновления в секундах
INTERVAL=1

# Файл для хранения последнего уровня заряда и состояния
STATUS_FILE="/tmp/battery_status.txt"

# Инициализация файла, если он не существует
if [ ! -f "$STATUS_FILE" ]; then
  echo "init" >"$STATUS_FILE"
fi

# Функция для определения батареи
get_battery_path() {
  for bat in /sys/class/power_supply/BAT*; do
    [ -d "$bat" ] && echo "$bat" && return
  done
  echo "Батарея не найдена" >$HOME/.suckless/scripts/dwmbScripts/.carrentsBattery
  exit 1
}

# Определяем путь к батарее
BATTERY_PATH=$(get_battery_path)

# Функция для получения заряда батареи и отображения соответствующей иконки
get_battery_status() {
  # Получаем информацию о батарее
  capacity=$(cat "$BATTERY_PATH/capacity")
  status=$(cat "$BATTERY_PATH/status")

  # Логика для состояния заряда
  if [ "$status" = "Charging" ]; then
    if [ "$capacity" -eq 100 ]; then
      icon="󰂅 " # Иконка для полностью заряженной батареи
    else
      icon=" " # Иконка зарядки
    fi
  elif [ "$status" = "Full" ]; then
    icon="󰁹" # Иконка для полной батареи
  else
    # Логика для разрядки батареи
    if [ "$capacity" -ge 90 ]; then
      icon="󰂂" # Батарея 90%
    elif [ "$capacity" -ge 80 ]; then
      icon="󰂁" # Батарея 80%
    elif [ "$capacity" -ge 70 ]; then
      icon="󰂀" # Батарея 70%
    elif [ "$capacity" -ge 60 ]; then
      icon="󰁿" # Батарея 60%
    elif [ "$capacity" -ge 50 ]; then
      icon="󰁾" # Батарея 50%
    elif [ "$capacity" -ge 40 ]; then
      icon="󰁽" # Батарея 40%
    elif [ "$capacity" -ge 30 ]; then
      icon="󰁼" # Батарея 30%
    elif [ "$capacity" -ge 20 ]; then
      icon="󰁺" # Батарея 20%
    else
      icon="󰂎" # Очень низкий заряд
    fi
  fi

  # Записываем уровень заряда с иконкой в файл
  echo "$icon $capacity%" >$HOME/.suckless/scripts/dwmbScripts/.carrentsBattery
  # Чтение последнего статуса и отправка уведомлений при изменении
  last_status=$(cat "$STATUS_FILE")
}

# Основной цикл для обновления информации каждые $INTERVAL секунд
while true; do
  get_battery_status
  sleep $INTERVAL
done
