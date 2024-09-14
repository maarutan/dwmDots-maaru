#!/bin/bash

# Интервал обновления в секундах
INTERVAL=1

# Файл для хранения последнего уровня заряда
STATUS_FILE="/tmp/battery_status.txt"

# Инициализация файла, если он не существует
if [ ! -f "$STATUS_FILE" ]; then
    echo "init" > "$STATUS_FILE"
fi

# Функция для получения заряда батареи и отображения соответствующей иконки
get_battery_status() {
    # Проверка наличия информации о батарее
    if [ ! -d /sys/class/power_supply/BAT1 ]; then
        echo "Батарея не найдена" > /home/maaru/suckless/scripts/dwmbScripts/.carrentsBattery
        return
    fi

    # Получаем информацию о батарее
    capacity=$(cat /sys/class/power_supply/BAT1/capacity)
    status=$(cat /sys/class/power_supply/BAT1/status)

    # Логика для состояния заряда
    if [ "$status" = "Charging" ]; then
        if [ "$capacity" -eq 100 ]; then
            icon="󰂅"  # Иконка для батареи, которая полностью зарядилась, но продолжает заряжаться
        else
            icon=""  # Иконка зарядки
        fi
    elif [ "$status" = "Full" ]; then
        icon="󰁹"  # Иконка для полной батареи
    else
        # Логика для разрядки батареи
        if [ "$capacity" -ge 90 ]; then
            icon="󰂂"  # Батарея 90%
        elif [ "$capacity" -ge 80 ]; then
            icon="󰂁"  # Батарея 80%
        elif [ "$capacity" -ge 70 ]; then
            icon="󰂀"  # Батарея 70%
        elif [ "$capacity" -ge 60 ]; then
            icon="󰁿"  # Батарея 60%
        elif [ "$capacity" -ge 50 ]; then
            icon="󰁾"  # Батарея 50%
        elif [ "$capacity" -ge 40 ]; then
            icon="󰁽"  # Батарея 40%
        elif [ "$capacity" -ge 30 ]; then
            icon="󰁼"  # Батарея 30%
        elif [ "$capacity" -ge 20 ]; then
            icon="󰁺"  # Батарея 20%
        else
            icon="󰂎"  # Очень низкий заряд
        fi
    fi

    # Записываем уровень заряда с иконкой в файл
    echo "$icon $capacity%" > /home/maaru/suckless/scripts/dwmbScripts/.carrentsBattery

    # Чтение последнего статуса и отправка уведомления при изменении
    last_status=$(cat "$STATUS_FILE")
    if [ "$capacity" -lt 10 ] && [ "$last_status" != "low" ]; then
        notify-send "Батарея" "Очень низкий заряд батареи: $capacity%" -u critical
        echo "low" > "$STATUS_FILE"
    elif [ "$capacity" -ge 30 ] && [ "$last_status" = "low" ]; then
        echo "normal" > "$STATUS_FILE"
    fi
}

# Основной цикл для обновления информации каждые $INTERVAL секунд
while true; do
    get_battery_status
    sleep $INTERVAL
done

