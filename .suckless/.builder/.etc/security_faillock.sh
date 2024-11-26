#!/bin/bash

faillock_conf="/etc/security/faillock.conf"

# Проверяем права суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Ошибка: Этот скрипт должен быть запущен с правами суперпользователя." >&2
    exit 1
fi

# Проверка существования файла конфигурации
if [ ! -f "$faillock_conf" ]; then
    echo "Ошибка: Файл $faillock_conf не найден!"
    exit 1
fi

# Создание резервной копии файла
backup_file="${faillock_conf}.bak.$(date +%Y%m%d%H%M%S)"
cp "$faillock_conf" "$backup_file"
echo "Резервная копия файла создана: $backup_file"

# Функция для проверки и добавления/обновления параметра
add_or_update_param() {
    local param=$1
    local value=$2

    if grep -q "^$param" "$faillock_conf"; then
        # Параметр существует, проверяем значение
        if grep -q "^$param = $value" "$faillock_conf"; then
            echo "Параметр $param уже установлен со значением $value. Изменения не требуются."
        else
            # Обновляем значение параметра
            sudo sed -i "s|^$param.*|$param = $value|" "$faillock_conf"
            echo "Параметр $param обновлён до значения $value."
        fi
    else
        # Добавляем параметр в конец файла
        echo "$param = $value" | sudo tee -a "$faillock_conf" > /dev/null
        echo "Добавлен параметр: $param = $value."
    fi
}

# Добавляем или обновляем параметры
echo ""
add_or_update_param "deny" "0"
add_or_update_param "unlock_time" "0"
add_or_update_param "fail_interval" "0"

# Завершающее сообщение
echo -e "\n====================================================="
echo "Все изменения завершены!"
echo "Теперь ошибки при вводе пароля не заблокируют учётную запись."
echo "====================================================="

