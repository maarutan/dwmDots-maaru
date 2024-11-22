#!/bin/sh

# Файл для сохранения ID тачпада
TOUCHPAD_ID_FILE="/tmp/touchpad_id.txt"

# Функция для поиска ID тачпада
find_touchpad_id() {
    xinput list | grep -i "Touchpad" | awk '{print $6}' | sed 's/id=//'
}

# Если ID ранее сохранён, загружаем его
if [ -f "$TOUCHPAD_ID_FILE" ]; then
    TOUCHPAD_ID=$(cat "$TOUCHPAD_ID_FILE")
else
    # Ищем ID тачпада
    TOUCHPAD_ID=$(find_touchpad_id)

    # Если тачпад не найден, завершаем скрипт
    if [ -z "$TOUCHPAD_ID" ]; then
        notify-send "Тачпад" "не найден" -i dialog-error
        exit 1
    fi

    # Сохраняем ID для будущего использования
    echo "$TOUCHPAD_ID" > "$TOUCHPAD_ID_FILE"
fi

# Проверка, доступен ли параметр "Device Enabled" у тачпада
DEVICE_ENABLED_PROP=$(xinput list-props "$TOUCHPAD_ID" 2>/dev/null | grep "Device Enabled")
if [ -z "$DEVICE_ENABLED_PROP" ]; then
    notify-send "Тачпад" " Не найден или параметр 'Device Enabled' отсутствует" -i dialog-error
    rm -f "$TOUCHPAD_ID_FILE" # Удаляем сохранённый ID
    exit 1
fi

# Текущий статус (1 - включено, 0 - выключено)
CURRENT_STATUS=$(echo "$DEVICE_ENABLED_PROP" | awk '{print $NF}')

# Переключение состояния
if [ "$CURRENT_STATUS" -eq 1 ]; then
    xinput disable "$TOUCHPAD_ID" && notify-send "Тачпад" "отключен" -i dialog-warning
else
    xinput enable "$TOUCHPAD_ID" && notify-send "Тачпад" "включен" -i dialog-information
fi

