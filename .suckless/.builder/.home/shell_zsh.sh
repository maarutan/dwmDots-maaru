#!/bin/bash

# Проверка на права суперпользователя
if [[ $EUID -ne 0 ]]; then
  echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)." >&2
  exit 1
fi

echo "Начинаем настройку Zsh, Powerlevel10k и конфигурации..."

# Установка zsh
echo "Устанавливаем zsh..."
if ! command -v zsh >/dev/null 2>&1; then
  pacman -Syu --noconfirm zsh
else
  echo "zsh уже установлен."
fi

# Установка Powerlevel10k
echo "Устанавливаем Powerlevel10k..."
if ! yay -Qs zsh-powerlevel10k-git >/dev/null 2>&1; then
  yay -S --noconfirm zsh-powerlevel10k-git
else
  echo "Powerlevel10k уже установлен."
fi

# Установка Oh My Zsh
echo "Устанавливаем Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh уже установлен."
fi

# Установка плагинов
echo "Устанавливаем плагины zsh-autosuggestions и zsh-syntax-highlighting..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
  echo "Плагин zsh-autosuggestions уже установлен."
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
  echo "Плагин zsh-syntax-highlighting уже установлен."
fi

# Замена конфигурационных файлов
CONFIG_SOURCE_DIR="$HOME/dwm_dots-maaru"
TARGET_FILES=(".zshrc" ".p10k.zsh")

for file in "${TARGET_FILES[@]}"; do
  TARGET="$HOME/$file"
  SOURCE="$CONFIG_SOURCE_DIR/$file"
  
  if [[ -f "$TARGET" ]]; then
    echo "Файл $TARGET уже существует. Удаляем..."
    rm -f "$TARGET"
  fi

  if [[ -f "$SOURCE" ]]; then
    echo "Копируем $SOURCE в $TARGET..."
    cp "$SOURCE" "$TARGET"
  else
    echo "Файл $SOURCE не найден! Проверьте, существует ли он в $CONFIG_SOURCE_DIR."
    exit 1
  fi
done

# Установка Zsh как оболочки по умолчанию
echo "Устанавливаем Zsh как оболочку по умолчанию..."
chsh -s $(which zsh)

echo "Установка завершена! Перезапустите терминал, чтобы увидеть изменения."
