#!/bin/bash

# Путь к файлу конфигурации
sddm_conf="/etc/sddm.conf"

# Проверка прав суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Ошибка: Этот скрипт должен быть запущен с правами суперпользователя." >&2
    exit 1
fi

# Создание резервной копии файла
if [ -f "$sddm_conf" ]; then
    backup_file="${sddm_conf}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$sddm_conf" "$backup_file"
    echo "Создана резервная копия файла: $backup_file"
else
    echo "Файл $sddm_conf не найден. Создаю новый файл с настройками..."
    echo -e "[Theme]\nCurrent=sugar-candy\nCursorTheme=Bibata-Modern-Ice\nCursorSize=48" | sudo tee "$sddm_conf" > /dev/null
    echo "Файл $sddm_conf создан."
    exit 0
fi

# Функция для обновления или добавления параметра
update_param() {
    local param=$1
    local value=$2

    if grep -q "^$param=" "$sddm_conf"; then
        sudo sed -i "s|^$param=.*|$param=$value|" "$sddm_conf"
        echo "Обновлён параметр: $param=$value."
    else
        echo "$param=$value" | sudo tee -a "$sddm_conf" > /dev/null
        echo "Добавлен параметр: $param=$value."
    fi
}

# Обновление параметров в секции [Theme]
if ! grep -q "^\[Theme\]" "$sddm_conf"; then
    echo -e "\n[Theme]" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Добавлена секция [Theme]."
fi

update_param "Current" "sugar-candy"
update_param "CursorTheme" "Bibata-Modern-Ice"
update_param "CursorSize" "48"

# Завершающее сообщение
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo "Конфигурация SDDM успешно обновлена."
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
