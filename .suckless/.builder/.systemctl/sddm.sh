#!/bin/bash

# Проверяем наличие SDDM
if ! pacman -Qs sddm > /dev/null 2>&1; then
    echo "SDDM не установлен. Устанавливаю..."
    if ! sudo pacman -S --noconfirm sddm; then
        echo "Ошибка: Не удалось установить SDDM. Проверьте подключение к интернету или репозитории." >&2
        exit 1
    fi
else
    echo "SDDM уже установлен."
fi

# Проверяем, запущена ли служба SDDM
if systemctl is-active --quiet sddm.service; then
    echo "Служба SDDM уже запущена."
else
    echo "Служба SDDM не запущена. Запускаю..."
    if ! sudo systemctl start sddm.service; then
        echo "Ошибка: Не удалось запустить службу SDDM." >&2
        exit 1
    fi
    echo "Служба SDDM успешно запущена."
fi

# Проверяем, включена ли служба SDDM при загрузке
if ! systemctl is-enabled --quiet sddm.service; then
    echo "Включаю автозапуск службы SDDM..."
    if ! sudo systemctl enable sddm.service; then
        echo "Ошибка: Не удалось включить автозапуск службы SDDM." >&2
        exit 1
    fi
    echo "Служба SDDM включена для автозапуска."
else
    echo "Служба SDDM уже включена для автозапуска."
fi

echo "SDDM успешно установлен и настроен."

