comozitor=("picom-simpleanims-git" )
python=("python311")
discord=("vencord")
ide=("visual-studio-code-bin" "pycharm-community-edition")
fonts=("noto-fonts" "noto-fonts-emoji" "ttf-firacode-nerd"
"ttf-jetbrain-mono-nerd" "figlet-fonts" "figlet-fonts-extra"
"ttf-dejavu" "ttf-fira-code" "ttf-roboto-mono")
torrent=("qbittorrent-qt5")
rofi=("rofi-emoji" "rofi-greenclip")
browser=("google-chrome")
term_utils=("cava" "unimatrix-git" "peaclock" "pokeget" "st")
checkupdate=("checkupdates-systemd-git")
touchpad=("libinput-gestures")
theme=("faba-icon-theme" )
brightnes=("brightnessctl")
office=("onlyoffice-bin")
minecraft=("prismlauncher")
applaunchers=("appimagelauncher")
zshtheme=("zsh-theme-powerlevel10k-git")

yay_packages=(
    "${comozitor[@]}" "${python[@]}" "${discord[@]}"
    "${ide[@]}" "${fonts[@]}" "${torrent[@]}"
    "${rofi[@]}" "${browser[@]}" "${term_utils[@]}"
    "${checkupdate[@]}" "${touchpad[@]}" "${theme[@]}"
    "${brightnes[@]}" "${office[@]}" "${minecraft[@]}"
    "${applaunchers[@]}" "${zshtheme[@]}"
)

for package in "${yay_packages[@]}"; do
    if ! yay -Qi "$package" > /dev/null 2>&1; then
        echo "Устанавливаю $package через yay..."
        yay -S --noconfirm "$package"
    else
        echo "$package уже установлен."
    fi
done


