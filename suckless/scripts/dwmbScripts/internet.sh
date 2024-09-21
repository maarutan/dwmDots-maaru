#!/bin/bash

# Проверяем наличие bc
if ! command -v bc &> /dev/null; then
    echo "bc не установлен. Установите bc, чтобы скрипт работал правильно." > $HOME/suckless/scripts/dwmbScripts/.currentInternet
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
    
    # Отладочный вывод
    echo "Интерфейс: $interface" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "rx_bytes_before: $rx_bytes_before" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "rx_bytes_after: $rx_bytes_after" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "tx_bytes_before: $tx_bytes_before" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "tx_bytes_after: $tx_bytes_after" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "rx_bytes: $rx_bytes" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "tx_bytes: $tx_bytes" >> $HOME/suckless/scripts/dwmbScripts/.debug.log
    echo "total_bytes: $total_bytes" >> $HOME/suckless/scripts/dwmbScripts/.debug.log

    # Преобразуем байты в более удобный формат
    if [ "$total_bytes" -ge 1048576 ]; then
        total_mb=$(echo "scale=2; $total_bytes / 1048576" | bc)
        echo "${total_mb} MB"
    elif [ "$total_bytes" -ge 1024 ]; then
        total_kb=$(echo "scale=2; $total_bytes / 1024" | bc)
        echo "${total_kb} KB"
    else
        echo "${total_bytes} B"
    fi
}

# Проверяем наличие сетевых интерфейсов и запускаем мониторинг для каждого активного
while true; do
    data_found=false
    for interface in $(ls /sys/class/net); do
        # Проверяем, что интерфейс активен
        if [ "$(cat /sys/class/net/$interface/operstate)" = "up" ]; then
            data=$(get_data $interface)
            if [ -n "$data" ]; then
                # Если данные не нулевые, выводим их
                if [[ "$data" != "0 B" ]]; then
                    echo "$data" > $HOME/suckless/scripts/dwmbScripts/.currentInternet
                else
                    echo "0 B" > $HOME/suckless/scripts/dwmbScripts/.currentInternet
                fi
                data_found=true
            fi
        fi
    done

    # Если нет активных интерфейсов, выводим 0
    if [ "$data_found" = false ]; then
        echo "0 B" > $HOME/suckless/scripts/dwmbScripts/.currentInternet
    fi
    
    sleep $INTERVAL
done

