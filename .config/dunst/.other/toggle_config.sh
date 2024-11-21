#!/bin/bash

# Путь к конфигурационной папке kitty
DUNST_CONFIG_DIR="$HOME/.config/dunst"
# Файлы конфигурации
DUNST_OPAQUE_CONF="$DUNST_CONFIG_DIR/.other/dunstrc_opacity1"       # Конфиг для nOpacity
DUNST_TRANSPARENT_CONF="$DUNST_CONFIG_DIR/.other/dunstrc_opacity08"  # Конфиг для default
DUNST_ACTIVE_CONF="$DUNST_CONFIG_DIR/dunstrc"                # Активный конфиг

# Проверяем, указан ли аргумент
if [ $# -lt 1 ]; then
    echo "Использование: $0 <конфигурация>"
    echo "Доступные конфигурации:"
    echo "  - nOpacity (применяет dunstrc_no_blur)"
    echo "  - default (применяет dunstrc_blur)"
    exit 1
fi

# Считываем аргумент
CONFIG_NAME="$1"

# Применяем выбранную конфигурацию
case "$CONFIG_NAME" in
    nOpacity)
        echo "Применяю конфигурацию 'nOpacity'..."
        cat "$DUNST_OPAQUE_CONF" > "$DUSNT_ACTIVE_CONF"
        ;;
    default)
        echo "Применяю конфигурацию 'default'..."
        cat "$DUNST_TRANSPARENT_CONF" > "$DUNST_ACTIVE_CONF"
        ;;
    *)
        echo "Ошибка: Неизвестная конфигурация '$CONFIG_NAME'."
        echo "Доступные конфигурации: nOpacity, default"
        exit 1
        ;;
esac

# Перезапускаем kitty, чтобы применить новый конфиг
pkill dunst
dunst &
echo "Готово! dunst использует конфигурацию '$CONFIG_NAME'."

