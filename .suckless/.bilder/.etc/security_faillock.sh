#!/bin/bash

faillock_conf="/etc/security/faillock.conf"

# Проверка существования файла конфигурации
if [ ! -f "$faillock_conf" ]; then
    echo -e "Ошибка: Файл $faillock_conf не найден!\n"
    exit 1
fi

# Функция для проверки и добавления строки в конец файла
add_to_end() {
    local param=$1
    local value=$2

    # Проверяем, есть ли строка с параметром (раскомментированная)
    if grep -q "^$param" "$faillock_conf"; then
        echo -e "Параметр $param уже существует. Изменения не требуются."
    else
        # Добавляем параметр в конец файла
        echo -e "$param = $value" | sudo tee -a "$faillock_conf" > /dev/null
        echo -e "\nДобавлено в конец файла: $param = $value."
    fi
}

# Добавляем параметры в конец файла
echo " "
add_to_end "deny" "0"
add_to_end "unlock_time" "0"
add_to_end "fail_interval" "0"
echo -e  "\n!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!"
echo -e "Все изменения завершены  \nтеперь если ты ошибешься при вводе пороля не чего страшного"
echo "!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!"

