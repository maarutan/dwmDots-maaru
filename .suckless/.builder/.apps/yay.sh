#!/bin/bash

# Проверяем, установлен ли yay
if ! command -v yay &> /dev/null; then
    echo "Ошибка: 'yay' не установлен. Установите его перед запуском этого скрипта." >&2
    exit 1
fi

# Определяем категории пакетов
comozitor=("picom-simpleanims-git")
python=("python311")
discord=("vencord")
ide=("visual-studio-code-bin" "pycharm-community-edition")
fonts=("noto-fonts" "noto-fonts-emoji" "ttf-firacode-nerd" "ttf-jetbrain-mono-nerd" "figlet-fonts" "figlet-fonts-extra" "ttf-dejavu" "ttf-fira-code" "ttf-roboto-mono")
torrent=("qbittorrent-qt5")
rofi=("rofi-emoji" "rofi-greenclip" "i3lock-color" )
browser=("google-chrome")
term_utils=("cava" "unimatrix-git" "peaclock" "pokeget" "st")
checkupdate=("checkupdates-systemd-git")
touchpad=("libinput-gestures")
theme=("faba-icon-theme")
brightnes=("brightnessctl")
office=("onlyoffice-bin")
minecraft=("prismlauncher")
applaunchers=("appimagelauncher")
zshtheme=("zsh-theme-powerlevel10k-git")

# Полный набор пакетов
all=(
    "${comozitor[@]}" "${python[@]}" "${discord[@]}"
    "${ide[@]}" "${fonts[@]}" "${torrent[@]}"
    "${rofi[@]}" "${browser[@]}" "${term_utils[@]}"
    "${checkupdate[@]}" "${touchpad[@]}" "${theme[@]}"
    "${brightnes[@]}" "${office[@]}" "${minecraft[@]}"
    "${applaunchers[@]}" "${zshtheme[@]}"
)

# Минимальный набор пакетов
quickstart=(
    "${zshtheme[@]}" "${brightnes[@]}" "${theme[@]}" "${touchpad[@]}"
    "${rofi[@]}" "${checkupdate[@]}" "${term_utils[@]}"
    "${fonts[@]}" "${python[@]}" "${comozitor[@]}"
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

# Установка пакетов через yay
echo ">>> Начинаю установку пакетов..."
for package in "${selected_packages[@]}"; do
    echo ">>> Проверяю $package..."
    if yay -Qi "$package" > /dev/null 2>&1; then
        echo ">>> $package уже установлен."
    else
        echo ">>> Устанавливаю $package через yay..."
        yay -S --noconfirm "$package" || {
            echo "Ошибка: Не удалось установить $package." >&2
            continue
        }
    fi
done

echo ">>> Установка завершена!"
