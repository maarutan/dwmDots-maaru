echo -e "


██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  
██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  
╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
 ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
                                                              
████████╗ ██████╗     ███╗   ███╗██╗   ██╗    ██████╗ ██╗    ██╗███╗   ███╗
╚══██╔══╝██╔═══██╗    ████╗ ████║╚██╗ ██╔╝    ██╔══██╗██║    ██║████╗ ████║
   ██║   ██║   ██║    ██╔████╔██║ ╚████╔╝     ██║  ██║██║ █╗ ██║██╔████╔██║
   ██║   ██║   ██║    ██║╚██╔╝██║  ╚██╔╝      ██║  ██║██║███╗██║██║╚██╔╝██║
   ██║   ╚██████╔╝    ██║ ╚═╝ ██║   ██║       ██████╔╝╚███╔███╔╝██║ ╚═╝ ██║
   ╚═╝    ╚═════╝     ╚═╝     ╚═╝   ╚═╝       ╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝
                                                                           
██████╗ ██╗   ██╗██╗██╗     ██████╗ ███████╗██████╗ 
██╔══██╗██║   ██║██║██║     ██╔══██╗██╔════╝██╔══██╗
██████╔╝██║   ██║██║██║     ██║  ██║█████╗  ██████╔╝
██╔══██╗██║   ██║██║██║     ██║  ██║██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝██║███████╗██████╔╝███████╗██║  ██║
╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝


"
sleep 4 
clear
echo -e"

████████ ██   ██ ██ ███████     ██ ███████ 
   ██    ██   ██ ██ ██          ██ ██      
   ██    ███████ ██ ███████     ██ ███████ 
   ██    ██   ██ ██      ██     ██      ██ 
   ██    ██   ██ ██ ███████     ██ ███████ 
                                           
                                           
██     ██  ██████  ██████  ██   ██     ███████  ██████  ██████  
██     ██ ██    ██ ██   ██ ██  ██      ██      ██    ██ ██   ██ 
██  █  ██ ██    ██ ██████  █████       █████   ██    ██ ██████  
██ ███ ██ ██    ██ ██   ██ ██  ██      ██      ██    ██ ██   ██ 
 ███ ███   ██████  ██   ██ ██   ██     ██       ██████  ██   ██ 



           ██            ██████   ██████ ██   ██     ██      ██ ███    ██ ██    ██ ██   ██          
          ████           ██   ██ ██      ██   ██     ██      ██ ████   ██ ██    ██  ██ ██  
          ▀████          ██████  ██      ███████     ██      ██ ██ ██  ██ ██    ██   ███         
        ██▄ ████         ██   ██ ██      ██   ██     ██      ██ ██  ██ ██ ██    ██  ██ ██        
       ██████████        ██   ██  ██████ ██   ██     ███████ ██ ██   ████  ██████  ██   ██       
      ████▀  ▀████     
     ████▀    ▀████
    ▀▀▀          ▀▀▀


"

sleep 4 

echo -e "

 1. Внесение изменений в конфигурацию пакета pacman.
 2. Изменение конфигурации security_faillock для улучшения безопасности.
 3. Установка и использование только дисплейного менеджера ssdm.
 4. Использование исключительно терминала kitty для работы в будущем.
 5. Добавление сессии dwm в дисплейный менеджер ssdm.
 6. Применение всех настроек из директории ~/dwm_dots-maaru в вашей домашней директории.
 7. Добавление конфигурационных файлов из .config в соответствии с настройками.
 8. Запуск необходимых сервисов через systemctl, настройка Bluetooth, буфера обмена и добавление панели Plank в dwm.
 
Правила:
 1. В будущем использовать только терминал kitty.
 2. Не переименовывать директорию .suckless, чтобы избежать проблем с именами скриптов.
 3. Для успешного билда репозиторий должен находиться в директории ~/dwm_dots-maaru. Эта директория должна оставаться без изменений.
 
"
echo -e "\n----------------------------------------------------------------------"
echo -e "Если вы готовы, нажмите y/n: "
read -r choice

if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Вы выбрали продолжить."
    # Здесь вы можете вставить последующие команды
elif [[ $choice == "n" || $choice == "N" ]]; then
    echo "Вы выбрали отмену."
    exit 0
else
    echo "Некорректный ввод. Пожалуйста, введите y или n."
    exit 1
fi

# etc - build
$HOME/dwm_dots-maaru/.suckless/.builder/.etc/pacman_conf.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.etc/security_faillock.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.etc/sddm.sh

# usr - build
$HOME/dwm_dots-maaru/.suckless/.builder/.usr/share_sddm.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.usr/xsessions.sh

# home - build
$HOME/dwm_dots-maaru/.suckless/.builder/.home/home.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.home/config.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.home/local_plank.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.home/validate_wp.sh
$HOME/dwm_dots-maaru/.suckless/.builder/.systemctl/bluethooth.sh


echo "Мы сейчас начнем установку приложений."
echo "Какой вариант установки вы хотите?"
echo "1 - quickstart"
echo "2 - all"
read -rp "Введите ваш выбор (1/2): " install_choice

# Проверка на корректность ввода
if [[ $install_choice -lt 1 || $install_choice -gt 2 ]]; then
    echo "Некорректный выбор. Пожалуйста, запустите скрипт заново и выберите 1 или 2."
    exit 1
fi

# Функция запуска скрипта с передачей аргумента
run_script() {
    local script="$1"
    local option="$2"
    if [[ -x "$script" ]]; then
        echo "Запуск $script с параметром $option..."
        "$script" "$option" || { echo "Ошибка выполнения $script"; exit 1; }
    else
        echo "Скрипт $script не найден или не является исполняемым."
        exit 1
    fi
}

# Установка pacman
if [[ $install_choice -eq 1 ]]; then
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/pacman.sh" "quickstart"
else
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/pacman.sh" "all"
fi

# Установка yay
if [[ $install_choice -eq 1 ]]; then
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/yay.sh" "quickstart"
else
    run_script "$HOME/dwm_dots-maaru/.suckless/.builder/.apps/yay.sh" "all"
fi

echo "Установка приложений завершена!"



# home zsh custom - build
sudo $HOME/dwm_dots-maaru/.suckless/.builder/.home/shell_zsh.sh

echo -e "
██████╗ ██╗    ██╗███╗   ███╗
██╔══██╗██║    ██║████╗ ████║
██║  ██║██║ █╗ ██║██╔████╔██║
██║  ██║██║███╗██║██║╚██╔╝██║
██████╔╝╚███╔███╔╝██║ ╚═╝ ██║
╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝
"
sleep 1
# dwm build
if [ -d "$HOME/.suckless/dwm" ]; then
  echo "Перекомпилирую dwm..."
  cd "$HOME/.suckless/dwm" || { notify-send "Не удается найти директорию dwm"; exit 1; }
  make clean install || { notify-send "Ошибка при перекомпиляции dwm"; exit 1; }
else
  notify-send "Директория dwm не найдена. Проверьте расположение."
fi

echo -e "
██████╗ ██╗    ██╗███╗   ███╗██████╗ ██╗      ██████╗  ██████╗██╗  ██╗███████╗
██╔══██╗██║    ██║████╗ ████║██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝
██║  ██║██║ █╗ ██║██╔████╔██║██████╔╝██║     ██║   ██║██║     █████╔╝ ███████╗
██║  ██║██║███╗██║██║╚██╔╝██║██╔══██╗██║     ██║   ██║██║     ██╔═██╗ ╚════██║
██████╔╝╚███╔███╔╝██║ ╚═╝ ██║██████╔╝███████╗╚██████╔╝╚██████╗██║  ██╗███████║
╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝
"
sleep 1
# dwmblocks build
if [ -d "$HOME/.suckless/dwmblocks" ]; then
  echo "Перекомпилирую dwmblocks..."
  cd "$HOME/.suckless/dwmblocks" || { notify-send "Не удается найти директорию dwmblocks"; exit 1; }
  sudo make clean install || { notify-send "Ошибка при перекомпиляции dwmblocks"; exit 1; }
else
  notify-send "Директория dwmblocks не найдена. Проверьте расположение."
fi

$HOME/.suckless/.builder/.etc/grub.sh
$HOME/.suckless/.builder/.systemctl/sddm.sh

sleep 7 
sudo reboot
