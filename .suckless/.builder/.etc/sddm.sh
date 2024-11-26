#!/bin/bash

# Путь к файлу конфигурации
sddm_conf="/etc/sddm.conf"

# Проверка, существует ли файл
if [ ! -f "$sddm_conf" ]; then
    # Если файл не существует, создаем новый с нужными настройками
    echo -e "[Theme]\nCurrent=sugar-candy\nCursorTheme=Bibata-Modern-Ice\nCursorSize=48" | sudo tee "$sddm_conf" > /dev/null
    echo -e "Файл $sddm_conf не найден. Он был создан с необходимыми параметрами."
    exit 0
fi

# Проверка наличия секции [Theme] и нужных параметров
if grep -q "\[Theme\]" "$sddm_conf"; then
    # Проверка, есть ли уже нужные строки в файле
    if grep -q "Current=sugar-candy" "$sddm_conf" && \
       grep -q "CursorTheme=Bibata-Modern-Ice" "$sddm_conf" && \
       grep -q "CursorSize=48" "$sddm_conf"; then
        echo -e "\nЭти конфигурации уже присутствуют в файле $sddm_conf.\nСкрипт не добавил новые параметры."
        exit 0
    fi
else
    # Если секции [Theme] нет, добавляем её
    echo -e "\n[Theme]" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Секция [Theme] добавлена в $sddm_conf."
fi

# Добавляем или проверяем параметры, если их нет
if ! grep -q "Current=sugar-candy" "$sddm_conf"; then
    echo "Current=sugar-candy" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Добавлен параметр Current=sugar-candy."
fi

if ! grep -q "CursorTheme=Bibata-Modern-Ice" "$sddm_conf"; then
    echo "CursorTheme=Bibata-Modern-Ice" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Добавлен параметр CursorTheme=Bibata-Modern-Ice."
fi

if ! grep -q "CursorSize=48" "$sddm_conf"; then
    echo "CursorSize=48" | sudo tee -a "$sddm_conf" > /dev/null
    echo "Добавлен параметр CursorSize=48."
fi


echo " "
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "Конфигурация SDDM обновлена."
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-"

