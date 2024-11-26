#!/bin/bash

# Папка с твоими дотфайлами
DOTFILES_DIR="$HOME/dwm_dots-maaru"

# Директория назначения
CONFIG_DIR="$HOME/.config"

# Файл для резервной копии
BACKUP_SUFFIX="_reserv_copy"

# Логирование
LOG_FILE="$HOME/copy_log.txt"
exec > >(tee -i "$LOG_FILE") 2>&1

# Цвета для оформления
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
COLOR_CYAN="\033[36m"
COLOR_BOLD="\033[1m"

# Проверка существования папки с дотфайлами
if [ ! -d "$DOTFILES_DIR" ] || [ -z "$(ls -A "$DOTFILES_DIR")" ]; then
    echo -e "${COLOR_RED}Ошибка: Директория $DOTFILES_DIR не найдена или пуста.${COLOR_RESET}"
    exit 1
fi

# Функция для создания резервной копии
create_backup() {
    local dir=$1
    local backup_dir="${dir}${BACKUP_SUFFIX}_$(date +%Y%m%d%H%M%S)"
    echo -e "${COLOR_GREEN}Создаю резервную копию $dir в $backup_dir...${COLOR_RESET}"
    cp -r "$dir" "$backup_dir"
    echo -e "${COLOR_GREEN}Резервная копия сохранена: $backup_dir${COLOR_RESET}"
}

# Функция для копирования содержимого
copy_dotfile_to_config() {
    local source=$1
    local target=$2

    if [ ! -e "$target" ]; then
        cp -rL "$source" "$target"
        echo -e "${COLOR_GREEN}Добавлено: $source в $target${COLOR_RESET}"
        return
    fi

    while true; do
        echo -e "${COLOR_YELLOW}Файл или директория $target уже существует.${COLOR_RESET}"
        read -p "$(echo -e "${COLOR_BOLD}Выберите действие (y - перезаписать, n - пропустить, r - резервная копия и перезапись): ${COLOR_RESET}")" choice
        case "$choice" in
            y|Y)
                cp -rL "$source" "$target"
                echo -e "${COLOR_GREEN}Скопировано: $source в $target${COLOR_RESET}"
                break
                ;;
            n|N)
                echo -e "${COLOR_YELLOW}Пропущено: $target${COLOR_RESET}"
                break
                ;;
            r|R)
                create_backup "$target"
                cp -rL "$source" "$target"
                echo -e "${COLOR_GREEN}Скопировано (с резервной копией): $source в $target${COLOR_RESET}"
                break
                ;;
            *)
                echo -e "${COLOR_RED}Неверный выбор. Попробуйте еще раз.${COLOR_RESET}"
                ;;
        esac
    done
}

# Проверка и копирование файлов
if [ -d "$CONFIG_DIR" ]; then
    read -p "$(echo -e "${COLOR_BOLD}Хотите создать резервную копию всей директории $CONFIG_DIR? (y/n): ${COLOR_RESET}")" backup_choice
    if [[ "$backup_choice" =~ ^[yY]$ ]]; then
        create_backup "$CONFIG_DIR"
    fi
else
    echo -e "${COLOR_GREEN}Создаю директорию $CONFIG_DIR...${COLOR_RESET}"
    mkdir -p "$CONFIG_DIR"
fi

# Копирование файлов из дотфайлов
for dir in "$DOTFILES_DIR"/.config/*; do
    if [[ $(basename "$dir") == ".git" ]]; then
        continue
    fi
    target_dir="$CONFIG_DIR/$(basename "$dir")"
    copy_dotfile_to_config "$dir" "$target_dir"
done

echo -e "${COLOR_GREEN}Все файлы успешно скопированы!${COLOR_RESET}"

