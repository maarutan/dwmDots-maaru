#!/bin/bash

# Путь к конфигурационной папке kitty
KITTY_CONFIG_DIR="$HOME/.config/kitty"

# Файлы конфигурации
KITTY_OPAQUE_CONF="$KITTY_CONFIG_DIR/.other/kitty_opacity_1.conf"       # Конфиг для nOpacity
KITTY_TRANSPARENT_CONF="$KITTY_CONFIG_DIR/.other/kitty_opacity_transparent.conf"  # Конфиг для default
KITTY_ACTIVE_CONF="$KITTY_CONFIG_DIR/kitty.conf"                # Активный конфиг

# Проверяем, указан ли аргумент
if [ $# -lt 1 ]; then
    echo "Использование: $0 <конфигурация>"
    echo "Доступные конфигурации:"
    echo "  - nOpacity (применяет kitty_opacity_1.conf)"
    echo "  - default (применяет kitty_opacity_transparent.conf)"
    exit 1
fi

# Считываем аргумент
CONFIG_NAME="$1"

# Применяем выбранную конфигурацию
case "$CONFIG_NAME" in
    nOpacity)
        echo "Применяю конфигурацию 'nOpacity'..."
        cat "$KITTY_OPAQUE_CONF" > "$KITTY_ACTIVE_CONF"
        ;;
    default)
        echo "Применяю конфигурацию 'default'..."
        cat "$KITTY_TRANSPARENT_CONF" > "$KITTY_ACTIVE_CONF"
        ;;
    *)
        echo "Ошибка: Неизвестная конфигурация '$CONFIG_NAME'."
        echo "Доступные конфигурации: nOpacity, default"
        exit 1
        ;;
esac

# Перезапускаем kitty, чтобы применить новый конфиг
kitty @ set-colors -a "$KITTY_ACTIVE_CONF"

echo "Готово! Kitty использует конфигурацию '$CONFIG_NAME'."

