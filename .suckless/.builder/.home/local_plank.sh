#!/bin/bash

# Определяем пути
THEME="Catppuccin-mocha"  # Название темы
SOURCE="$HOME/.dwm_dots-maaru/.local/share/plank/themes/$THEME"  # Путь к исходной теме
DESTINATION="$HOME/.local/share/plank/themes/"  # Путь назначения
DEST_THEME="$DESTINATION$THEME"  # Полный путь к теме в папке назначения

# Проверяем, существует ли папка plank/themes в директории назначения
if [ ! -d "$DESTINATION" ]; then
    # Создаем директорию, если её нет
    mkdir -p "$DESTINATION"
    echo "Создана директория '$DESTINATION'"
fi

# Проверяем, существует ли тема в исходной директории
if [ -d "$SOURCE" ]; then
    # Проверяем, существует ли уже такая тема в папке назначения
    if [ -d "$DEST_THEME" ]; then
        echo "Тема '$THEME' уже существует в '$DESTINATION'. Перемещение отменено."
    else
        # Копируем тему
        cp -r "$SOURCE" "$DESTINATION"
        echo "Тема '$THEME' успешно скопирована в '$DESTINATION'"
    fi
else
    echo "Тема '$THEME' не найдена в '$SOURCE'. Убедись, что она существует."
    exit 1
fi

# Запуск plank с настройками
echo "сейчас вам надо зайти в настроки в plank и выбрать тему для него"
sleep 1 
echo "1 до запуска настроек "
sleep 1 
echo "2 до запуска настроек "
sleep 1 
echo "3 до запуска настроек "
sleep 1 
echo "Запускаем Plank с настройками..."
plank --preferences &  # Запускаем настройки Plank

# Уведомление
notify-send "Plank Theme" "Тема '$THEME' готова к применению. Откройте настройки Plank для выбора."

# Опрос
while true; do
    echo "Вы применили тему '$THEME' в Plank? (y/n):"
    read -r RESPONSE
    echo -e "\n-------------------------------------------"
    case $RESPONSE in
        [Yy]* ) 
            echo "Отлично! Тема '$THEME' успешно применена."
            break
            ;;
        [Nn]* )
            echo "Вы не применили тему. Пожалуйста, настройте Plank вручную."
            break
            ;;
        * )
            echo "Пожалуйста, ответьте 'y' (да) или 'n' (нет)."
            ;;
    esac
    echo -e "\n-------------------------------------------"
done

