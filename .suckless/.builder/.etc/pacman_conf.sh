#!/bin/bash

pacman_conf="/etc/pacman.conf"

# Проверяем права суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Ошибка: Этот скрипт должен быть запущен с правами суперпользователя." >&2
    exit 1
fi

# Проверка существования файла конфигурации
if [ ! -f "$pacman_conf" ]; then
    echo "Ошибка: Файл $pacman_conf не найден!"
    exit 1
fi

# Создание резервной копии файла
backup_file="${pacman_conf}.bak.$(date +%Y%m%d%H%M%S)"
cp "$pacman_conf" "$backup_file"
echo "Создана резервная копия файла: $backup_file"

# Включение цветной поддержки и добавление ILoveCandy
if grep -q "#Color" "$pacman_conf"; then
    sudo sed -i 's/#Color/Color/' "$pacman_conf"
    echo "Включена поддержка цвета для pacman."
fi

if ! grep -q "ILoveCandy" "$pacman_conf"; then
    sudo sed -i '/Color/a ILoveCandy' "$pacman_conf"
    echo "Добавлен ILoveCandy для красивой анимации загрузки."
fi

# Установка ParallelDownloads = 15
if grep -q "^#ParallelDownloads" "$pacman_conf"; then
    sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 15/' "$pacman_conf"
    echo "Включено ParallelDownloads с параметром 15."
elif grep -q "^ParallelDownloads" "$pacman_conf"; then
    sudo sed -i 's/^ParallelDownloads.*/ParallelDownloads = 15/' "$pacman_conf"
    echo "Обновлено значение ParallelDownloads до 15."
else
    echo "ParallelDownloads не найден. Добавляем новую строку..."
    echo "ParallelDownloads = 15" | sudo tee -a "$pacman_conf" > /dev/null
    echo "Добавлена строка ParallelDownloads = 15."
fi

# Завершающее сообщение
echo -e "\nПроверка и обновление pacman.conf завершены!"
