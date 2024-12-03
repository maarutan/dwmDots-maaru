#!/bin/bash

# Путь к папке и префикс для названия файлов
source_folder="$(pwd)"  # Замените на путь к вашей папке
prefix="bg"  # Замените на желаемый префикс для файлов

# Проверяем, что папка существует
if [ ! -d "$source_folder" ]; then
  echo "Папка '$source_folder' не существует."
  exit 1
fi

# Создаем массив для хранения всех файлов
files=()

# Проходим по всем файлам в папке и добавляем их в массив
for file in "$source_folder"/*; do
  if [ -f "$file" ]; then
    files+=("$file")
  fi
done

# Сортируем массив файлов по имени
IFS=$'\n' sorted_files=($(printf "%s\n" "${files[@]}" | sort -V))
unset IFS

# Счетчик для файлов
index=1

# Переименовываем все файлы, чтобы они шли подряд по возрастанию
for file in "${sorted_files[@]}"; do
  if [ -f "$file" ]; then
    # Получаем расширение файла
    extension="${file##*.}"
    # Формируем новое имя файла с префиксом и индексом
    new_file_name="$prefix-$index.$extension"
    new_file_path="$source_folder/$new_file_name"
    # Переименовываем файл, добавляя временный префикс, чтобы избежать конфликтов
    temp_file_path="$source_folder/temp-$index.$extension"
    mv "$file" "$temp_file_path"
    ((index++))
  fi
done

# Обновляем список временных файлов и переименовываем их окончательно
temp_files=("$source_folder"/temp-*)
index=1
for temp_file in "${temp_files[@]}"; do
  if [ -f "$temp_file" ]; then
    # Формируем окончательное имя файла
    new_file_name="$prefix-$index.${temp_file##*.}"
    new_file_path="$source_folder/$new_file_name"
    mv "$temp_file" "$new_file_path"
    ((index++))
  fi
done

echo "Файлы успешно переименованы!"

