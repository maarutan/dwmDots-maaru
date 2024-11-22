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
clipboard=("xclip")
colorPicker=("xcolor" "gpick")
filerepo=("flatpak")
machinelanguage=("python" "python-pip" "nodejs" "npm")
shell=("zsh")
git=("git" "lazygit" "github-cli")


pacman=(
    "${fetch[@]}" "${xorg[@]}" "${editor[@]}"
    "${filemanager[@]}" "${qt[@]}" "${monitoring[@]}"
    "${terminal[@]}" "${global[@]}" "${image[@]}"
    "${plants[@]}" "${filework[@]}" "${fonts[@]}"
    "${browsers[@]}" "${terminalUtils[@]}" "${screenloader[@]}"
    "${clipboard[@]}" "${colorPicker[@]}" "${filerepo[@]}"
    "${machinelanguage[@]}" "${shell[@]}" "${git[@]}")

for package in "${pacman[@]}"; do
    if ! pacman -Qi "$package" > /dev/null 2>&1; then
        echo "Устанавливаю $package..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "$package уже установлен."
    fi
done

