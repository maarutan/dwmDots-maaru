#!/bin/bash

# Проверка на наличие пакетов bluez, bluez-utils, blueman
packages=('bluez' 'bluez-utils' 'blueman')

for package in "${packages[@]}"; do
    # Проверка, установлен ли пакет
    if ! pacman -Qs "$package" > /dev/null; then
        echo "$package не установлен. Устанавливаю..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package уже установлен."
    fi
done

# Проверка статуса службы Bluetooth
echo "Проверка службы Bluetooth..."
if systemctl is-active --quiet bluetooth; then
    echo "Служба Bluetooth уже работает."
else
    echo "Служба Bluetooth не работает. Запускаю..."
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth
    echo "Bluetooth служба запущена и включена при старте системы."
fi

