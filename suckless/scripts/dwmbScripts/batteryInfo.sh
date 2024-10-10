#!/bin/bash

# Интервал обновления в секундах
INTERVAL=1

# Файл для хранения последнего уровня заряда
STATUS_FILE="/tmp/battery_status.txt"
PREVIOUS_CAPACITY_FILE="/tmp/previous_capacity.txt"

# Инициализация файлов, если они не существуют
if [ ! -f "$STATUS_FILE" ]; then
  echo "init" >"$STATUS_FILE"
fi

if [ ! -f "$PREVIOUS_CAPACITY_FILE" ]; then
  echo 100 >"$PREVIOUS_CAPACITY_FILE" # Инициализация значением, чтобы уведомления не срабатывали сразу
fi

# Функция для получения иконки батареи
get_battery_icon() {
  case $1 in
  100) echo "󰁹" ;; # Полная батарея
  90) echo "󰂂" ;;  # Батарея 90%
  80) echo "󰂁" ;;  # Батарея 80%
  70) echo "󰂀" ;;  # Батарея 70%
  60) echo "󰁿" ;;  # Батарея 60%
  50) echo "󰁾" ;;  # Батарея 50%
  40) echo "󰁽" ;;  # Батарея 40%
  30) echo "󰁼" ;;  # Батарея 30%
  20) echo "󰁺" ;;  # Батарея 20%
  *) echo "󰂎" ;;   # Очень низкий заряд
  esac
}

# Функция для получения заряда батареи и отображения соответствующей иконки
get_battery_status() {
  # Проверка наличия информации о батарее
  if [ ! -d /sys/class/power_supply/BAT1 ] ||
    [ ! -f /sys/class/power_supply/BAT1/capacity ] ||
    [ ! -f /sys/class/power_supply/BAT1/status ]; then
    echo "Батарея не найдена" >$HOME/suckless/scripts/dwmbScripts/.carrentsBattery
    return
  fi

  # Получаем информацию о батарее
  capacity=$(cat /sys/class/power_supply/BAT1/capacity)
  status=$(cat /sys/class/power_supply/BAT1/status)

  # Получаем иконку батареи
  if [ "$status" = "Charging" ]; then
    if [ "$capacity" -eq 100 ]; then
      icon="󰂅" # Полностью заряженная батарея
    else
      icon="" # Иконка зарядки
    fi
  else
    icon=$(get_battery_icon "$capacity")
  fi

  # Записываем уровень заряда с иконкой в файл
  echo "$icon $capacity%" >$HOME/suckless/scripts/dwmbScripts/.carrentsBattery

  # Чтение предыдущего уровня заряда и последнего статуса
  previous_capacity=$(cat "$PREVIOUS_CAPACITY_FILE")
  last_status=$(cat "$STATUS_FILE")

  # Логика уведомлений
  if [ "$capacity" -le 5 ]; then
    if [ "$last_status" != "critical" ]; then
      notify-send "Батарея" "Критически низкий заряд: $capacity%" -u critical
      echo "critical" >"$STATUS_FILE"
    fi

  elif [ "$capacity" -lt 30 ]; then
    if [ "$last_status" != "low" ]; then
      notify-send "Батарея" "Предупреждение: заряд всего $capacity%" -u normal
      echo "low" >"$STATUS_FILE"
    fi

  elif [ "$capacity" -ge 50 ]; then
    # Проверка, работает ли picom
    if pgrep picom >/dev/null; then
      pkill picom
      notify-send "Батарея" "Picom отключен. Уровень заряда: $capacity%" -u normal
    fi
    echo "normal" >"$STATUS_FILE"
  fi

  # Уведомление при достаточном заряде (80% и выше, если идет зарядка)
  if [ "$capacity" -ge 80 ] && [ "$status" = "Charging" ]; then
    if [ "$last_status" != "sufficient" ]; then
      notify-send "Батарея" "Заряд достаточный: $capacity%" -u normal
      echo "sufficient" >"$STATUS_FILE"
    fi
  fi

  # Обновляем предыдущий уровень заряда
  echo "$capacity" >"$PREVIOUS_CAPACITY_FILE"
}

# Основной цикл для обновления информации каждые $INTERVAL секунд
while true; do
  get_battery_status
  sleep $INTERVAL
done
