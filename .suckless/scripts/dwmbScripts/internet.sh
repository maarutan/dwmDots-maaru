#!/bin/bash

# Проверяем наличие bc
if ! command -v bc &> /dev/null; then
    echo "bc не установлен. Установите bc, чтобы скрипт работал правильно." > $HOME/.suckless/scripts/dwmbScripts/.currentInternet
    exit 1
fi

# Интервал обновления в секундах
INTERVAL=1

# Функция для получения объема переданных данных за интервал времени
get_data() {
    local interface=$1

    # Получаем количество байт переданных и принятых данных до интервала
    rx_bytes_before=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx_bytes_before=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    sleep $INTERVAL
    
    # Получаем количество байт переданных и принятых данных после интервала
    rx_bytes_after=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx_bytes_after=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    # Вычисляем количество данных, переданных за интервал времени
    rx_bytes=$((rx_bytes_after - rx_bytes_before))
    tx_bytes=$((tx_bytes_after - tx_bytes_before))
    
    total_bytes=$((rx_bytes + tx_bytes))

    # Преобразуем байты в удобный формат и формируем строку фиксированной ширины
    if [ "$total_bytes" -ge 1048576 ]; then
        total_mb=$(echo "scale=2; $total_bytes / 1048576" | bc)
        data="${total_mb} MB"
    elif [ "$total_bytes" -ge 1024 ]; then
        total_kb=$(echo "scale=2; $total_bytes / 1024" | bc)
        data="${total_kb} KB"
    else
        data="${total_bytes} B"
    fi

    # Центрируем строку до 9 символов, добавляя пробелы с обеих сторон
    length=${#data}
    if [ $length -lt 9 ]; then
        padding=$(( (9 - length) / 2 ))
        data=$(printf "%*s" $((padding + length)) "$data")
        data=$(printf "%-9s" "$data")
    fi

    echo "$data"
}

# Основной цикл, сохраняющий данные в файл для активного интерфейса
while true; do
    data_found=false
    for interface in $(ls /sys/class/net); do
        if [ -f "/sys/class/net/$interface/operstate" ] && [ "$(cat /sys/class/net/$interface/operstate)" = "up" ]; then
            data=$(get_data $interface)
            echo "$data" > $HOME/.suckless/scripts/dwmbScripts/.currentInternet
            data_found=true
            break
        fi
    done

    # Если нет активных интерфейсов, выводим 0
    if [ "$data_found" = false ]; then
        echo "   0 B   " > $HOME/.suckless/scripts/dwmbScripts/.currentInternet
    fi
    
    sleep $INTERVAL
done
