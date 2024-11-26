#!/bin/bash

# Проверяем, установлен ли yay
if ! command -v yay &> /dev/null; then
  echo "Ошибка: yay не установлен. Установите yay перед запуском этого скрипта." >&2
  exit 1
fi

# Проверяем, установлен ли plymouth
if ! pacman -Qs plymouth > /dev/null; then
  echo "Plymouth не установлен. Устанавливаем..."
  if ! sudo pacman -S --noconfirm plymouth; then
    echo "Ошибка: Не удалось установить plymouth." >&2
    exit 1
  fi
else
  echo "Plymouth уже установлен."
fi

# Проверяем, установлен ли plymouth-theme-monoarch
if ! pacman -Qs plymouth-theme-monoarch > /dev/null; then
  echo "Plymouth-theme-monoarch не установлен. Устанавливаем..."
  if ! yay -S --noconfirm plymouth-theme-monoarch; then
    echo "Ошибка: Не удалось установить plymouth-theme-monoarch." >&2
    exit 1
  fi
else
  echo "Plymouth-theme-monoarch уже установлен."
fi

# Проверка на настройки GRUB
GRUB_FILE="/etc/default/grub"
GRUB_CMDLINE_VALUE="quiet splash loglevel=3"
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUB_CMDLINE_VALUE\"" "$GRUB_FILE"; then
  echo "Настройки GRUB уже применены. Пропускаем изменение."
else
  echo "Настройки GRUB не применены. Применяем изменения..."
  sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\".*\"|GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUB_CMDLINE_VALUE\"|" "$GRUB_FILE" || {
    echo "Ошибка: Не удалось обновить настройки GRUB." >&2
    exit 1
  }
  echo "Настройки GRUB обновлены."
fi

# Обновляем настройки GRUB
echo "Перегенерируем конфигурацию GRUB..."
if ! sudo grub-mkconfig -o /boot/grub/grub.cfg; then
  echo "Ошибка: Не удалось обновить конфигурацию GRUB." >&2
  exit 1
fi

echo "Настройка завершена!"

