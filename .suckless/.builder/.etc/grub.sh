#!/bin/bash

# Проверяем, установлен ли plymouth и plymouth-theme-monoarch
if ! pacman -Qs plymouth > /dev/null; then
  echo "Plymouth не установлен. Устанавливаем..."
  sudo pacman -S --noconfirm plymouth
fi

if ! pacman -Qs plymouth-theme-monoarch > /dev/null; then
  echo "Plymouth-theme-monoarch не установлен. Устанавливаем..."
  yay -S --noconfirm plymouth-theme-monoarch
fi

# Проверка на настройки GRUB
GRUB_CMDLINE="GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash loglevel=3\""
if grep -q "$GRUB_CMDLINE" /etc/default/grub; then
  echo "Настройки GRUB уже применены. Пропускаем изменение."
else
  echo "Настройки GRUB не применены. Применяем изменения..."
  sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/'"$GRUB_CMDLINE"'/g' /etc/default/grub
  echo "Настройки GRUB обновлены."
fi

# Обновляем настройки GRUB
echo "Перегенерируем конфигурацию GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Настройка завершена!"

