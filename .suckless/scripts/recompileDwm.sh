#!/bin/sh

# Проверка необходимых инструментов
command -v make >/dev/null 2>&1 || { notify-send "Не найден make"; exit 1; }
command -v gcc >/dev/null 2>&1 || { notify-send "Не найден gcc"; exit 1; }

# Переход в директорию с исходниками dwm
cd "$HOME/.suckless/dwm" || { notify-send "Не удается найти директорию dwm"; exit 1; }

# Определяем, доступны ли оптимизации
if command -v ccache >/dev/null 2>&1 && command -v nproc >/dev/null 2>&1; then
    # Используем ccache и параллельную компиляцию
    export CC="ccache gcc"
    CORES=$(nproc)
    if make -j"$CORES" clean install; then
        notify-send "dwm успешно перекомпилирован с оптимизациями"
    else
        notify-send "Ошибка при перекомпиляции dwm"
        exit 1
    fi
else
    # Работаем как раньше
    if make clean install; then
        notify-send "dwm успешно перекомпилирован (без оптимизаций)"
    else
        notify-send "Ошибка при перекомпиляции dwm"
        exit 1
    fi
fi

