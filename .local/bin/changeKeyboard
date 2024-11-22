#!/bin/bash

# Путь к общей иконке
COMMON_ICON="$HOME/.icons/myIcons/language.svg"

# Уникальный ID для уведомления
NOTIFY_ID=9999

# Получаем информацию о раскладке
layout=$(xset -q | grep LED | awk '{ if (substr($10,5,1) == 1) print "Russian"; else print "English"; }')

# Отправляем или обновляем уведомление через dunst с общим ID
dunstify -r $NOTIFY_ID -i "$COMMON_ICON" "            $layout"
