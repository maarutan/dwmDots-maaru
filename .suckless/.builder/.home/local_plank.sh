#!/bin/bash

# Проверяем наличие Plank
if ! command -v plank &> /dev/null; then
    echo "Ошибка: Plank не установлен. Установите его перед запуском скрипта."
    exit 1
fi

# Определяем пути
SOURCE_DIR="$HOME/dwm_dots-maaru/.local/share/plank/themes"
DESTINATION="$HOME/.local/share/plank/themes"

# Проверяем наличие исходной директории с темами
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: Исходная папка с темами '$SOURCE_DIR' не найдена."
    exit 1
fi

# Создаём директорию назначения, если её нет
if [ ! -d "$DESTINATION" ]; then
    mkdir -p "$DESTINATION"
    echo "Создана директория '$DESTINATION'"
fi

# Выбор темы
echo "Доступные темы:"
themes=($(ls "$SOURCE_DIR"))
select theme in "${themes[@]}"; do
    if [[ -n "$theme" ]]; then
        echo "Вы выбрали тему: $theme"
        THEME="$theme"
        break
    else
        echo "Неверный выбор. Попробуйте ещё раз."
    fi
done

# Проверка существования темы
SOURCE="$SOURCE_DIR/$THEME"
DEST_THEME="$DESTINATION/$THEME"

if [ ! -d "$SOURCE" ]; then
    echo "Ошибка: Тема '$THEME' не найдена в '$SOURCE'."
    exit 1
fi

# Проверяем, существует ли тема в целевой директории
if [ -d "$DEST_THEME" ]; then
    echo "Тема '$THEME' уже существует в '$DESTINATION'."
    read -p "Хотите перезаписать её? (y/n): " overwrite
    if [[ "$overwrite" =~ ^[yY]$ ]]; then
        echo "Создаю резервную копию существующей темы..."
        mv "$DEST_THEME" "${DEST_THEME}_backup_$(date +%Y%m%d%H%M%S)"
        echo "Резервная копия создана."
        cp -r "$SOURCE" "$DESTINATION"
        echo "Тема '$THEME' успешно обновлена."
    else
        echo "Перезапись отменена. Выход."
        exit 0
    fi
else
    cp -r "$SOURCE" "$DESTINATION"
    echo "Тема '$THEME' успешно скопирована в '$DESTINATION'."
fi

# Запуск настроек Plank
echo "Запускаем настройки Plank..."
plank --preferences &  # Открываем настройки Plank

# Уведомление
notify-send "Plank Theme" "Тема '$THEME' готова к применению. Откройте настройки Plank для выбора."

# Завершающее сообщение
echo "Тема '$THEME' установлена. Пожалуйста, выберите её в настройках Plank."

