#!/bin/bash

# Проверка на права суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Ошибка: Запустите скрипт с правами суперпользователя (sudo)." >&2
    exit 1
fi

# Определяем категории пакетов
global=("openssh" "telegram-desktop" "flameshot" "tree")
xorg=("xorg" "xorg-server" "xorg-xinit" "xdotool")
filemanager=("yazi" "nemo" "ranger")
qt=("qt5ct" "qt6ct" "qt5-svg" "qt5-quickcontrols2" "qt5-quickcontrols" "qt5-graphicaleffects")
fetch=("neofetch" "fastfetch")
editor=("neovim" "nano")
monitoring=("btop" "htop")
terminal=("kitty" "alacritty")
image=("feg" "imagemagick")
plants=("lxappearance")
filework=("unzip" "rsync" "ouch")
fonts=("ttf-fira-code" "ttf-jetbrains-mono" "figlet")
browsers=("firefox" "chromium")
terminalUtils=("fzf" "z" "zoxide" "exa")
screenloader=("plymouth")
clipboard=("xclip" "xsel")
colorPicker=("xcolor" "gpick")
filerepo=("flatpak")
machinelanguage=("python" "python-pip" "nodejs" "npm")
shell=("zsh")
git=("git" "lazygit" "github-cli")
starter=("sddm")

# Полный набор пакетов (all)
all=(
    "${fetch[@]}" "${xorg[@]}" "${editor[@]}"
    "${filemanager[@]}" "${qt[@]}" "${monitoring[@]}"
    "${terminal[@]}" "${global[@]}" "${image[@]}"
    "${plants[@]}" "${filework[@]}" "${fonts[@]}"
    "${browsers[@]}" "${terminalUtils[@]}" "${screenloader[@]}"
    "${clipboard[@]}" "${colorPicker[@]}" "${filerepo[@]}"
    "${machinelanguage[@]}" "${shell[@]}" "${git[@]}"
    "${starter[@]}"
)

# Минимальный набор пакетов (quickstart)
quickstart=(
    "${qt[@]}" "${fetch[@]}" "${monitoring[@]}" "${filework[@]}"
    "${fonts[@]}" "${image[@]}" "${clipboard[@]}" "${xorg[@]}"
    "${filemanager[@]}" "${editor[@]}" "${terminal[@]}" "${browsers[@]}"
    "${terminalUtils[@]}" "${colorPicker[@]}" "${filerepo[@]}"
    "${shell[@]}" "${git[@]}" "${starter[@]}"
)

# Проверяем наличие аргумента
if [[ -z $1 ]]; then
    echo "Ошибка: необходимо указать параметр запуска."
    echo "Доступные параметры:"
    echo "  quickstart - минимальный набор пакетов"
    echo "  all        - полный набор пакетов"
    exit 1
fi

# Выбор пакетов на основе аргумента
case $1 in
    quickstart)
        selected_packages=("${quickstart[@]}")
        ;;
    all)
        selected_packages=("${all[@]}")
        ;;
    *)
        echo "Ошибка: неверный параметр '$1'."
        echo "Доступные параметры:"
        echo "  quickstart - минимальный набор пакетов"
        echo "  all        - полный набор пакетов"
        exit 1
        ;;
esac

# Установка пакетов через pacman
echo ">>> Начинаю установку пакетов..."
for package in "${selected_packages[@]}"; do
    if pacman -Qi "$package" > /dev/null 2>&1; then
        echo ">>> $package уже установлен."
    else
        echo ">>> Устанавливаю $package..."
        sudo pacman -S --noconfirm "$package" || {
            echo "Ошибка: Не удалось установить $package." >&2
            continue
        }
    fi
done

echo ">>> Установка завершена!"
