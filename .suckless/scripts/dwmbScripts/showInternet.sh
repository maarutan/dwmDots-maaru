#!/bin/bash

# Определение иконок для Wi-Fi в зависимости от уровня сигнала
get_wifi_icon() {
  local signal_strength=$1

  if [ "$signal_strength" -ge 65 ]; then
    echo "▁▃▅▇"  # Иконка для сильного сигнала
  elif [ "$signal_strength" -ge 55 ]; then
    echo "▁▃▅⎽"  # Иконка для среднего сигнала
  elif [ "$signal_strength" -ge 40 ]; then
    echo "▁▃⎽⎽"  # Иконка для слабого сигнала
  elif [ "$signal_strength" -ge 20 ]; then
    echo "▁⎽⎽⎽"  # Иконка для очень слабого сигнала
  else
    echo "⎽⎽⎽⎽"  # Иконка для отсутствующего сигнала
  fi
}
# Проверка на наличие nmcli
if ! command -v nmcli &> /dev/null; then
  echo "nmcli не найдено. Установите NetworkManager." > $HOME/.suckless/scripts/dwmbScripts/.currentShowInternet
  exit 1
fi

# Бесконечный цикл для обновления статуса подключения каждую секунду
while true; do
  # Получение статуса подключений
  wifi_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "wifi:connected")
  ethernet_status=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep "ethernet:connected")

  # Если подключен Wi-Fi
  if [ -n "$wifi_status" ]; then
    # Получаем уровень сигнала Wi-Fi
    signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi list | grep "*" | cut -d':' -f2)
    if [ -z "$signal" ]; then
      signal=0
    fi
    wifi_icon=$(get_wifi_icon "$signal")
    echo "$wifi_icon" > $HOME/.suckless/scripts/dwmbScripts/.currentShowInternet

  # Если подключен Ethernet
  elif [ -n "$ethernet_status" ]; then
    echo "󰈀" > $HOME/.suckless/scripts/dwmbScripts/.currentShowInternet

  # Если нет подключения
  else
    echo "󰌙" > $HOME/.suckless/scripts/dwmbScripts/.currentShowInternet
  fi

  # Ожидание 1 секунды перед следующим обновлением
  sleep 1
done

