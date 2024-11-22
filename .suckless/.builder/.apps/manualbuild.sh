#!/bin/bash

# Проверка, установлен ли yay
if ! command -v yay &> /dev/null; then
    echo "yay не найден. Начинаю установку..."

    # Убедимся, что установлен git
    if ! pacman -Qi git &> /dev/null; then
        echo "Устанавливаю git..."
        sudo pacman -S --noconfirm git
    fi

    # Клонируем репозиторий yay
    echo "Клонирую репозиторий yay..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin

    # Установка yay
    cd /tmp/yay-bin
    echo "Устанавливаю yay..."
    makepkg -si --noconfirm

    # Очистка временных файлов
    cd ~
    rm -rf /tmp/yay-bin

    echo "yay успешно установлен."
else
    echo "yay уже установлен."
fi

