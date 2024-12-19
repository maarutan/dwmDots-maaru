#!/bin/bash

# Пути
TMUX_DIR="$HOME/.tmux"
TMUX_CONF="$TMUX_DIR/tmux.conf"
TMUX_CONF_LINK="$HOME/.tmux.conf"

# Проверяем наличие директории ~/.tmux
if [ ! -d "$TMUX_DIR" ]; then
    echo "❌ Директория $TMUX_DIR не найдена. Убедитесь, что конфигурация находится в $TMUX_DIR."
    exit 1
fi

# Проверяем наличие основного конфигурационного файла
if [ ! -f "$TMUX_CONF" ]; then
    echo "❌ Файл $TMUX_CONF не найден. Убедитесь, что файл tmux.conf существует."
    exit 1
fi

# Создаем символическую ссылку
if [ -L "$TMUX_CONF_LINK" ]; then
    echo "🔄 Ссылка $TMUX_CONF_LINK уже существует. Пересоздаем..."
    rm "$TMUX_CONF_LINK"
elif [ -f "$TMUX_CONF_LINK" ]; then
    echo "❌ Файл $TMUX_CONF_LINK уже существует, но это не ссылка. Удаляем..."
    rm "$TMUX_CONF_LINK"
fi

ln -s "$TMUX_CONF" "$TMUX_CONF_LINK"
echo "✅ Символическая ссылка создана: $TMUX_CONF_LINK -> $TMUX_CONF"

# Перезагружаем конфигурацию tmux (если активен)
if tmux info &>/dev/null; then
    echo "♻️  Перезагружаем конфигурацию tmux..."
    tmux source-file "$TMUX_CONF"
    echo "✅ Конфигурация tmux успешно перезагружена!"
else
    echo "ℹ️  tmux не запущен. Вы можете начать работать с tmux командой: tmux"
fi
