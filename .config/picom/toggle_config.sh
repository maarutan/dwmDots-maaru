#!/bin/bash

# Проверка переданного режима
if [[ "$1" == "default" ]]; then
    CONFIG1="$HOME/.config/picom/picom_no_anims.conf"
    CONFIG2="$HOME/.config/picom/picom_simple_anims.conf"
elif [[ "$1" == "glass" ]]; then
    CONFIG1="$HOME/.config/picom/picom_no_anims_glass.conf"
    CONFIG2="$HOME/.config/picom/picom_simple_anims_glass.conf"
else
    echo "Укажите режим: 'default' или 'glass'"
    exit 1
fi

# Файл для хранения последнего использованного конфига
LAST_CONFIG_FILE="$HOME/.config/picom/last_config_$1.txt"

# Проверка существования файла последней конфигурации
if [ ! -f "$LAST_CONFIG_FILE" ]; then
    echo "$CONFIG1" > "$LAST_CONFIG_FILE"
fi

# Чтение последней использованной конфигурации
LAST_CONFIG=$(cat "$LAST_CONFIG_FILE")

# Переключение на другой конфиг
if [ "$LAST_CONFIG" == "$CONFIG1" ]; then
    NEW_CONFIG="$CONFIG2"
else
    NEW_CONFIG="$CONFIG1"
fi

# Сохранение нового конфигурационного пути
echo "$NEW_CONFIG" > "$LAST_CONFIG_FILE"

# Перезапуск picom с новым конфигом
pkill picom
sleep .3
picom --config "$NEW_CONFIG"
