sudo localectl set-x11-keymap us,ru pc105 '' ctrl:nocaps,grp:ctrl_alt_toggle
# Баннер
echo -e "


██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  
██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  
╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
 ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

"

# Функция для запуска скриптов
run_script() {
    local script="$1"
    if [ ! -x "$script" ]; then
        echo "Ошибка: Скрипт $script не найден или не является исполняемым."
        exit 1
    fi
    echo "Запуск $script..."
    "$script" || { echo "Ошибка выполнения $script"; exit 1; }
}

# Подтверждение пользователя
echo -e "\n----------------------------------------------------------------------"
echo -e "Если вы готовы, нажмите y/n: "
read -r choice

if [[ $choice != "y" && $choice != "Y" ]]; then
    echo "Операция отменена."
    exit 0
fi

# Запуск конфигурационных скриптов
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.etc/pacman_conf.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.etc/security_faillock.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.etc/sddm.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.usr/share_sddm.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.usr/xsessions.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.home/home.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.home/config.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.home/local_plank.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.home/validate_wp.sh"
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.systemctl/bluethooth.sh"

# Установка пакетов
echo "Мы сейчас начнем установку приложений."
echo "Какой вариант установки вы хотите?"
echo "1 - quickstart"
echo "2 - all"
read -rp "Введите ваш выбор (1/2): " install_choice

if [[ $install_choice -eq 1 ]]; then
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/pacman.sh" "quickstart"
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/yay.sh" "quickstart"
elif [[ $install_choice -eq 2 ]]; then
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/pacman.sh" "all"
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/yay.sh" "all"
else
    echo "Некорректный выбор. Перезапустите скрипт."
    exit 1
fi

echo "Установка приложений завершена!"

# Установка zsh
run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.home/shell_zsh.sh"

# Перекомпиляция dwm
if [ -d "$HOME/.suckless/dwm" ]; then
    echo "Перекомпилирую dwm..."
    cd "$HOME/.suckless/dwm" && make clean install || { echo "Ошибка при компиляции dwm"; exit 1; }
else
    echo "Директория dwm не найдена."
fi

# Перекомпиляция dwmblocks
if [ -d "$HOME/.suckless/dwmblocks" ]; then
    echo "Перекомпилирую dwmblocks..."
    cd "$HOME/.suckless/dwmblocks" && sudo make clean install || { echo "Ошибка при компиляции dwmblocks"; exit 1; }
else
    echo "Директория dwmblocks не найдена."
fi

# Настройка GRUB
run_script "$HOME/.suckless/.builder/.etc/grub.sh"

# Настройка SDDM
run_script "$HOME/.suckless/.builder/.systemctl/sddm.sh"

# Перезагрузка
$HOME/dwm_dots-maaru/.suckless/.builder/.etc/tty_fonts.sh
read -p "Хотите перезагрузить систему сейчас? (y/n): " reboot_choice
if [[ $reboot_choice =~ ^[yY]$ ]]; then
    sudo reboot
else
    echo "Перезагрузка отменена. Завершение работы скрипта."
fi
