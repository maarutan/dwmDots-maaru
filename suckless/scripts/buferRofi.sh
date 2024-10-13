#!/bin/bash

# Для X11
if command -v xclip &> /dev/null; then
    clip_content=$(xclip -o -selection clipboard)
elif command -v xsel &> /dev/null; then
    clip_content=$(xsel --clipboard --output)
# Для Wayland
elif command -v wl-paste &> /dev/null; then
    clip_content=$(wl-paste)
else
    echo "Не удается найти утилиту для работы с буфером обмена."
    exit 1
fi

# Запуск rofi с содержимым буфера обмена
echo "$clip_content" | $HOME/.config/rofi/launchers/type-2/bufer.sh


