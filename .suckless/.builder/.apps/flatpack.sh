#!/bin/bash

# Проверяем, установлен ли flatpak
if ! command -v flatpak &> /dev/null; then
    echo "Ошибка: Flatpak не установлен. Установите его перед запуском этого скрипта." >&2
    exit 1
fi

# Определяем список команд для установки приложений
flatpak_commands=(
    "flatpak install -y flathub com.valvesoftware.Steam"
    "flatpak install -y flathub com.obsproject.Studio"
)

echo ">>> Начинаю установку приложений через Flatpak..."

# Установка приложений
for command in "${flatpak_commands[@]}"; do
    app_name=$(echo "$command" | awk '{print $NF}')
    echo ">>> Проверяю $app_name..."
    if ! flatpak list | grep -q "$app_name"; then
        echo ">>> Устанавливаю $app_name через flatpak..."
        if ! eval "$command"; then
            echo "Ошибка: Не удалось установить $app_name." >&2
            continue
        fi
    else
        echo ">>> $app_name уже установлен."
    fi
done

echo ">>> Установка завершена!"

