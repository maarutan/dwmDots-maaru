#!/bin/bash

# Проверка, установлен ли yay
if command -v yay &> /dev/null; then
    echo "yay уже установлен."
    exit 0
fi

echo "yay не найден. Начинаю установку..."

# Убедимся, что установлен git
if ! pacman -Qi git &> /dev/null; then
    echo "Устанавливаю git..."
    sudo pacman -S --noconfirm git || { echo "Ошибка: Не удалось установить git"; exit 1; }
fi

# Удаление конфликтующих пакетов
conflicting_packages=("yay-debug" "yay-bin-debug")
for pkg in "${conflicting_packages[@]}"; do
    if pacman -Qs "$pkg" > /dev/null; then
        echo "Обнаружен конфликтующий пакет $pkg. Удаляю..."
        sudo pacman -Rns --noconfirm "$pkg" || { echo "Ошибка: Не удалось удалить $pkg"; exit 1; }
    fi
done

# Очистка возможных конфликтующих файлов
conflicting_files=(
    "/usr/lib/debug/usr/bin/yay.debug"
    "/usr/share/locale/*/LC_MESSAGES/yay.mo"
)
for file in "${conflicting_files[@]}"; do
    if [ -e "$file" ]; then
        echo "Удаляю конфликтующий файл $file..."
        sudo rm -rf "$file" || { echo "Ошибка: Не удалось удалить $file"; exit 1; }
    fi
done

# Клонирование репозитория yay
YAY_DIR="/tmp/yay-bin"
if [ -d "$YAY_DIR" ]; then
    echo "Удаляю старую копию репозитория $YAY_DIR..."
    rm -rf "$YAY_DIR"
fi

echo "Клонирую репозиторий yay..."
git clone https://aur.archlinux.org/yay-bin.git "$YAY_DIR" || { echo "Ошибка: Не удалось клонировать репозиторий yay"; exit 1; }

# Сборка и установка yay
cd "$YAY_DIR" || { echo "Ошибка: Не удалось перейти в директорию $YAY_DIR"; exit 1; }
makepkg -si --noconfirm || { echo "Ошибка: Не удалось установить yay"; exit 1; }

# Проверка установки
if command -v yay &> /dev/null; then
    echo "yay успешно установлен."
else
    echo "Ошибка: yay не установлен."
    exit 1
fi
