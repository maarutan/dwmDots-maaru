#!/bin/bash
# Скрипт для подсчета общего количества доступных обновлений

# Функция для обработки ошибок
handle_error() {
    echo "Ошибка: $1" >&2
    exit 1
}

# Создаем директорию для скриптов, если её нет
mkdir -p ~/suckless/scripts

# Бесконечный цикл
while true; do
    # Получаем количество доступных обновлений для пакетов с paru
    paru_updates=$(paru -Qu 2>/dev/null | wc -l || echo 0)
    # Убедимся, что paru_updates является числом
    if ! [[ "$paru_updates" =~ ^[0-9]+$ ]]; then
        handle_error "Не удалось получить обновления paru"
    fi

    # Получаем количество доступных обновлений для пакетов с pacman
    pacman_updates=$(pacman -Qu 2>/dev/null | wc -l || echo 0)
    # Убедимся, что pacman_updates является числом
    if ! [[ "$pacman_updates" =~ ^[0-9]+$ ]]; then
        handle_error "Не удалось получить обновления pacman"
    fi

    # Считаем общее количество обновлений
    total_updates=$((paru_updates + pacman_updates))

    # Выводим только число
    echo "$total_updates" > ~/suckless/scripts/dwmbScripts/.currentInfoUpDate
    
    # Пауза в 1 секунду
    sleep 2
done

