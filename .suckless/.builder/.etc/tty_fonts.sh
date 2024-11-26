#!/bin/bash

# Убедимся, что скрипт выполняется с правами суперпользователя
if [[ $EUID -ne 0 ]]; then
  echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)."
  exit 1
fi

echo "Начинаем настройку шрифта TTY и локалей..."

# 1. Установка необходимых шрифтов
echo "Устанавливаем пакет terminus-font..."
pacman -Syu --noconfirm terminus-font || { echo "Ошибка установки terminus-font"; exit 1; }

# 2. Применение шрифта cyr-sun16 временно
echo "Применяем шрифт cyr-sun16 временно..."
setfont /usr/share/kbd/consolefonts/cyr-sun16.psfu.gz || { echo "Ошибка применения шрифта cyr-sun16"; exit 1; }

# 3. Настройка шрифта на постоянной основе
echo "Настраиваем шрифт cyr-sun16 на постоянной основе..."
if [ ! -f /etc/vconsole.conf ]; then
  touch /etc/vconsole.conf
fi

grep -q "FONT=cyr-sun16" /etc/vconsole.conf || echo "FONT=cyr-sun16" >> /etc/vconsole.conf

# 4. Настройка локалей
echo "Настраиваем локали..."

# Проверка и раскомментирование необходимых локалей
if [ -f /etc/locale.gen ]; then
  sed -i 's/#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  sed -i 's/#\(ru_RU.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  sed -i 's/#\(pl_PL.UTF-8 UTF-8\)/\1/' /etc/locale.gen
else
  echo "Ошибка: файл /etc/locale.gen не найден. Убедитесь, что файл существует."
  exit 1
fi

# Генерация локалей
locale-gen || { echo "Ошибка генерации локалей"; exit 1; }

# Установка локали по умолчанию
echo "Укажите локаль по умолчанию (например, ru_RU.UTF-8 или pl_PL.UTF-8):"
read -rp "Введите локаль: " default_locale

if [[ -z "$default_locale" ]]; then
  echo "Локаль не указана. Устанавливаем ru_RU.UTF-8 по умолчанию."
  default_locale="ru_RU.UTF-8"
fi

localectl set-locale LANG="$default_locale" || { echo "Ошибка установки локали $default_locale"; exit 1; }

# 5. Перезагрузка для применения изменений
echo "Настройка завершена. Рекомендуется перезагрузить систему."
echo "Good !!!"
sleep 1
