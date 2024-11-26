#!/bin/bash

# Проверка прав суперпользователя
if [[ $EUID -ne 0 ]]; then
  echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)." >&2
  exit 1
fi

echo "Начинаем настройку Zsh, Powerlevel10k и конфигурации..."

# Проверка наличия yay
if ! command -v yay >/dev/null 2>&1; then
  echo "Ошибка: yay не установлен. Установите yay перед запуском этого скрипта." >&2
  exit 1
fi

# Установка Zsh
echo "Устанавливаем Zsh..."
if ! command -v zsh >/dev/null 2>&1; then
  if ! pacman -Syu --noconfirm zsh; then
    echo "Ошибка: не удалось установить Zsh." >&2
    exit 1
  fi
else
  echo "Zsh уже установлен."
fi

# Установка Powerlevel10k
echo "Устанавливаем Powerlevel10k..."
if ! yay -Qs zsh-powerlevel10k-git >/dev/null 2>&1; then
  if ! yay -S --noconfirm zsh-powerlevel10k-git; then
    echo "Ошибка: не удалось установить Powerlevel10k." >&2
    exit 1
  fi
else
  echo "Powerlevel10k уже установлен."
fi

# Установка Oh My Zsh
echo "Устанавливаем Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Ошибка: curl или wget не установлены. Установите их перед запуском скрипта." >&2
    exit 1
  fi
else
  echo "Oh My Zsh уже установлен."
fi

# Установка плагинов
echo "Устанавливаем плагины zsh-autosuggestions и zsh-syntax-highlighting..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "Плагин zsh-autosuggestions уже установлен."
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "Плагин zsh-syntax-highlighting уже установлен."
fi

# Замена конфигурационных файлов с резервным копированием
CONFIG_SOURCE_DIR="$HOME/dwm_dots-maaru"
TARGET_FILES=(".zshrc" ".p10k.zsh")

for file in "${TARGET_FILES[@]}"; do
  TARGET="$HOME/$file"
  SOURCE="$CONFIG_SOURCE_DIR/$file"
  
  if [[ -f "$TARGET" ]]; then
    BACKUP="${TARGET}_backup_$(date +%Y%m%d%H%M%S)"
    echo "Создаём резервную копию: $TARGET -> $BACKUP"
    mv "$TARGET" "$BACKUP"
  fi

  if [[ -f "$SOURCE" ]]; then
    echo "Копируем $SOURCE в $TARGET..."
    cp "$SOURCE" "$TARGET"
  else
    echo "Ошибка: файл $SOURCE не найден! Проверьте, существует ли он в $CONFIG_SOURCE_DIR." >&2
    exit 1
  fi
done

# Установка Zsh как оболочки по умолчанию
echo "Устанавливаем Zsh как оболочку по умолчанию..."
if ! chsh -s "$(which zsh)"; then
  echo "Ошибка: не удалось установить Zsh как оболочку по умолчанию." >&2
  exit 1
fi

echo "Установка завершена! Перезапустите терминал, чтобы увидеть изменения."
sleep 1
exit 
