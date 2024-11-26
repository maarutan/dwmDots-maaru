#!/bin/bash

# Массив со списком скриптов
SCRIPTS=(
    "$HOME/.suckless/scripts/dwmbScripts/batteryInfo.sh"
    "$HOME/.suckless/scripts/dwmbScripts/internet.sh"
    "$HOME/.suckless/scripts/dwmbScripts/showInternet.sh"
    "$HOME/.suckless/scripts/dwmbScripts/updateInfo.sh"
    "$HOME/.suckless/scripts/dwmbScripts/memory.sh"
    "$HOME/.suckless/scripts/dwmbScripts/weather.sh"
)

# Перезапуск всех скриптов из списка
for script in "${SCRIPTS[@]}"; do
    # Убиваем старый процесс скрипта
    pkill -f "$script" && echo "Остановлен: $script"
    
    # Запускаем новый процесс скрипта
    "$script" & 
    echo "Запущен: $script"
done
