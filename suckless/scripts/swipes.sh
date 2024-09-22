#!/bin/bash

# Файл для хранения текущего рабочего стола
WS_FILE="$HOME/.current_workspace"

# Если файл не существует, создаем его и устанавливаем текущий рабочий стол на 1
if [ ! -f "$WS_FILE" ]; then
    echo 1 > "$WS_FILE"
fi

# Читаем текущий рабочий стол
CURRENT_WS=$(cat "$WS_FILE")

if [ "$1" == "right" ]; then
    # Увеличиваем номер рабочего стола, если он меньше 5
    if [ "$CURRENT_WS" -lt 5 ]; then
        CURRENT_WS=$((CURRENT_WS + 1))
    fi
elif [ "$1" == "left" ]; then
    # Уменьшаем номер рабочего стола, если он больше 1
    if [ "$CURRENT_WS" -gt 1 ]; then
        CURRENT_WS=$((CURRENT_WS - 1))
    fi
fi

# Обновляем файл с текущим рабочим столом
echo "$CURRENT_WS" > "$WS_FILE"

# Переключаемся на текущий рабочий стол
xdotool key --clearmodifiers super+"$CURRENT_WS"

