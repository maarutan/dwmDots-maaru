#!/bin/bash

APP_NAME="mechvibes"

APP_PATH="/usr/bin/mechvibes"

if pgrep -x "$APP_NAME" > /dev/null; then
    echo "$APP_NAME запущен. Завершаю..."
    pkill -x "$APP_NAME"
else
    echo "$APP_NAME не запущен. Запускаю..."
    "$APP_PATH" &
fi

