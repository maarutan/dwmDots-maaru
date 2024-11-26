#!/bin/bash

# Проверка прав суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен быть запущен с правами суперпользователя." >&2
    exit 1
fi

# Проверка наличия systemctl
if ! command -v systemctl > /dev/null 2>&1; then
    echo "Ошибка: systemctl не найден. Убедитесь, что используется systemd." >&2
    exit 1
fi

# Список пакетов для установки
packages=('bluez' 'bluez-utils' 'blueman')

# Установка пакетов
echo "Проверяем и устанавливаем необходимые пакеты..."
for package in "${packages[@]}"; do
    if ! pacman -Qs "$package" > /dev/null; then
        echo "$package не установлен. Устанавливаю..."
        if ! sudo pacman -S --noconfirm "$package"; then
            echo "Ошибка: Не удалось установить $package. Проверьте подключение к интернету или репозитории." >&2
            exit 1
        fi
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
    if ! sudo systemctl start bluetooth; then
        echo "Ошибка: Не удалось запустить службу Bluetooth." >&2
        exit 1
    fi

    if ! sudo systemctl enable bluetooth; then
        echo "Ошибка: Не удалось включить автозапуск службы Bluetooth." >&2
        exit 1
    fi

    echo "Служба Bluetooth успешно запущена и включена при старте системы."
fi

echo "Настройка Bluetooth завершена!"

