#!/bin/bash

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

# Полный набор пакетов (all)
all=(
    "${fetch[@]}" "${xorg[@]}" "${editor[@]}"
    "${filemanager[@]}" "${qt[@]}" "${monitoring[@]}"
    "${terminal[@]}" "${global[@]}" "${image[@]}"
    "${plants[@]}" "${filework[@]}" "${fonts[@]}"
    "${browsers[@]}" "${terminalUtils[@]}" "${screenloader[@]}"
    "${clipboard[@]}" "${colorPicker[@]}" "${filerepo[@]}"
    "${machinelanguage[@]}" "${shell[@]}" "${git[@]}"
)

# Минимальный набор пакетов (quickstart)
quickstart=(
    "${qt[@]}" "${fetch[@]}" "${monitoring[@]}" "${filework[@]}"
    "${fonts[@]}" "${image[@]}" "${clipboard[@]}" "${xorg[@]}"
    "${filemanager[@]}" "${editor[@]}" "${terminal[@]}" "${browsers[@]}"
    "${terminalUtils[@]}" "${colorPicker[@]}" "${filerepo[@]}"
    "${shell[@]}" "${git[@]}"
)

# Проверяем наличие аргумента
if [[ -z $1 ]]; then
    echo "Ошибка: необходимо указать параметр запуска."
    echo "Использование: $0 [quickstart|all]"
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
        echo "Используйте 'quickstart' для минимального набора или 'all' для полного."
        exit 1
        ;;
esac

# Установка пакетов через pacman
for package in "${selected_packages[@]}"; do
    if ! pacman -Qi "$package" > /dev/null 2>&1; then
        echo "Устанавливаю $package через pacman..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package уже установлен."
    fi
done

echo "Установка завершена!"
