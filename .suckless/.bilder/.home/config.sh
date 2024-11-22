#!/bin/bash

# Папка с твоими дотфайлами
DOTFILES_DIR="$HOME/.dwm_dots-maaru"

# Директория назначения
CONFIG_DIR="$HOME/.config"

# Файл для резервной копии
BACKUP_SUFFIX="_reserv_copy"

# Переменная для массового выбора
global_choice=""

# Цвета для оформления
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
COLOR_CYAN="\033[36m"
COLOR_BOLD="\033[1m"

# Функция для создания резервной копии
create_backup() {
    local dir=$1
    local backup_dir="${dir}${BACKUP_SUFFIX}_$(date +%Y%m%d%H%M%S)"  # Уникальный суффикс с временем
    
    echo -e "${COLOR_GREEN}Создаю резервную копию содержимого $dir в $backup_dir...${COLOR_RESET}"
    cp -r "$dir" "$backup_dir"
    echo -e "${COLOR_GREEN}Резервная копия сохранена в $backup_dir${COLOR_RESET}"
}

# Функция для копирования содержимого
copy_dotfile_to_config() {
    local source=$1
    local target=$2

    # Если файла нет в целевой директории, сразу копируем
    if [ ! -e "$target" ]; then
        cp -r "$source" "$target"
        echo -e "${COLOR_GREEN}Добавлено: $source в $target${COLOR_RESET}"
        return
    fi

    # Если массовый выбор уже сделан
    if [[ "$global_choice" =~ ^[yYrR]$ ]]; then
        if [[ "$global_choice" == "r" || "$global_choice" == "R" ]]; then
            create_backup "$target"
        fi
        cp -r "$source" "$target" && echo -e "${COLOR_GREEN}Скопировано: $source в $target${COLOR_RESET}" || echo -e "${COLOR_RED}Ошибка при копировании $source${COLOR_RESET}"
    elif [[ "$global_choice" == "n" || "$global_choice" == "N" ]]; then
        echo -e "${COLOR_YELLOW}Пропущено: $target${COLOR_RESET}"
    else
        # Индивидуальный выбор для каждого файла
        while true; do
            echo -e "${COLOR_YELLOW}Файл или директория $target уже существует.${COLOR_RESET}"
            read -p "$(echo -e "${COLOR_BOLD}Выберите действие для файла (y - перезаписать, n - пропустить, r - резервная копия и перезапись, a - для всех перезаписать, s - пропустить все): ${COLOR_RESET}")" file_choice

            case "$file_choice" in
                y|Y)
                    cp -r "$source" "$target"
                    echo -e "${COLOR_GREEN}Скопировано: $source в $target${COLOR_RESET}"
                    break
                    ;;
                n|N)
                    echo -e "${COLOR_YELLOW}Пропущено: $target${COLOR_RESET}"
                    break
                    ;;
                r|R)
                    create_backup "$target"
                    cp -r "$source" "$target"
                    echo -e "${COLOR_GREEN}Скопировано (с резервной копией): $source в $target${COLOR_RESET}"
                    break
                    ;;
                a|A)
                    global_choice="y"
                    cp -r "$source" "$target"
                    echo -e "${COLOR_GREEN}Скопировано: $source в $target${COLOR_RESET}"
                    break
                    ;;
                s|S)
                    global_choice="n"
                    echo -e "${COLOR_YELLOW}Пропускаем все оставшиеся файлы.${COLOR_RESET}"
                    break
                    ;;
                *)
                    echo -e "${COLOR_RED}Неверный выбор. Попробуйте еще раз.${COLOR_RESET}"
                    ;;
            esac
        done
    fi
}

# Проверка резервного копирования и копирование
check_and_copy() {
    echo -e "${COLOR_CYAN}-----------------------------------------------------------------------------------${COLOR_RESET}"

    # Проверяем, существует ли .config
    if [ -d "$CONFIG_DIR" ]; then
        echo -e "${COLOR_YELLOW}Директория $CONFIG_DIR уже существует.${COLOR_RESET}"
        while true; do
            read -p "$(echo -e "${COLOR_BOLD}Хотите создать резервную копию всей директории $CONFIG_DIR? (y/n): ${COLOR_RESET}")" backup_choice
            case "$backup_choice" in
                y|Y)
                    create_backup "$CONFIG_DIR"
                    break
                    ;;
                n|N)
                    echo -e "${COLOR_YELLOW}Пропущено создание резервной копии для $CONFIG_DIR.${COLOR_RESET}"
                    break
                    ;;
                *)
                    echo -e "${COLOR_RED}Неверный выбор. Пожалуйста, выберите y или n.${COLOR_RESET}"
                    ;;
            esac
        done
    else
        echo -e "${COLOR_GREEN}Директория $CONFIG_DIR не существует. Создаю...${COLOR_RESET}"
        mkdir -p "$CONFIG_DIR"
    fi

    # Копирование содержимого из твоих дотфайлов
    echo -e "${COLOR_CYAN}Копирую содержимое .config из $DOTFILES_DIR в $CONFIG_DIR...${COLOR_RESET}"

    for dir in "$DOTFILES_DIR"/.config/*; do
        target_dir="$CONFIG_DIR/$(basename "$dir")"
        copy_dotfile_to_config "$dir" "$target_dir"
    done

    echo -e "${COLOR_GREEN}Все файлы скопированы!${COLOR_RESET}"
}

# Начало работы
echo -e "${COLOR_CYAN}-----------------------------------------------------------------------------------${COLOR_RESET}"
echo -e "${COLOR_YELLOW}Этот скрипт позволяет перезаписывать файлы, пропускать их или создавать резервную копию перед перезаписью.${COLOR_RESET}"
echo -e "${COLOR_CYAN}-----------------------------------------------------------------------------------${COLOR_RESET}"
check_and_copy

