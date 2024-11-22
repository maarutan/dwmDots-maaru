flatpak_commands=(
    "flatpak install -y flathub com.valvesoftware.Steam"
    "flatpak install -y flathub com.obsproject.Studio"
)

for command in "${flatpak_commands[@]}"; do
    app_name=$(echo "$command" | awk '{print $NF}')
    if ! flatpak list | grep -q "$app_name"; then
        echo "Устанавливаю $app_name через flatpak..."
        eval "$command"
    else
        echo "$app_name уже установлен."
    fi
done

