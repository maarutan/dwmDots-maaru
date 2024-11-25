#!/bin/bash

# Проверка, что путь к репозиторию был передан в качестве аргумента
if [ -z "$1" ]; then
  echo "Пожалуйста, укажите путь к репозиторию!"
  exit 1
fi

# Путь к репозиторию
REPO_DIR="$1"

# Проверяем, существует ли указанный репозиторий
if [ ! -d "$REPO_DIR" ]; then
  echo "Репозиторий не найден по пути: $REPO_DIR"
  exit 1
fi

# Получаем имя текущего пользователя
CURRENT_USER=$(whoami)

# Ищем все символьные ссылки в репозитории
find "$REPO_DIR" -type l | while read symlink; do
  # Получаем путь, на который указывает символьная ссылка
  TARGET=$(readlink "$symlink")

  # Проверяем, содержит ли путь "/home/"
  if [[ "$TARGET" == /home/* ]]; then
    # Определяем старый путь (например, "/home/user/")
    OLD_PATH=$(echo "$TARGET" | cut -d '/' -f1-3)  # "/home/user"

    # Новый путь с домашней директорией текущего пользователя
    NEW_TARGET="${TARGET/$OLD_PATH/$HOME}"

    # Удаляем старую символьную ссылку
    rm "$symlink"

    # Создаем новую символьную ссылку
    ln -s "$NEW_TARGET" "$symlink"
    echo "Символьная ссылка обновлена: $symlink -> $NEW_TARGET"
  fi
done
