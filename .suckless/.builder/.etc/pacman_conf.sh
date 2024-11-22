#!/bin/bash

pacman_conf="/etc/pacman.conf"

# Проверка существования файла конфигурации
if [ ! -f "$pacman_conf" ]; then
    echo -e "Ошибка: Файл $pacman_conf не найден!\n"
    exit 1
fi

# Проверка и изменение #Color на Color, добавление ILoveCandy
if grep -q "#Color" "$pacman_conf"; then
    sudo sed -i 's/#Color/Color/' "$pacman_conf"
    sudo sed -i '/Color/a ILoveCandy' "$pacman_conf"
    echo -e "Теперь у pacman есть поддержка цветов.\nДобавлена красивая загрузка ILoveCandy.\n"
else
    # Если строка Color уже существует, добавляем ILoveCandy, если его нет
    if grep -q "Color" "$pacman_conf" && ! grep -q "ILoveCandy" "$pacman_conf"; then
        sudo sed -i '/Color/a ILoveCandy' "$pacman_conf"
        echo -e "ILoveCandy добавлен после Color.\n"
    else
        echo -e "Изменения по Color и ILoveCandy не требуются.\n"
    fi
fi

# Проверка и изменение #ParallelDownloads = 5 на ParallelDownloads = 15
if grep -q "#ParallelDownloads = 5" "$pacman_conf"; then
    sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 15/' "$pacman_conf"
    echo -e "Добавлена строка ParallelDownloads = 15.\n"
else
    echo -e "Строка #ParallelDownloads не найдена. Изменение не требуется.\n"
fi

echo -e "Проверка и обновление завершены!\n"

