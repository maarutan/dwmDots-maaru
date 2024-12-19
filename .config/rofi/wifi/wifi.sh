#!/usr/bin/env bash

# Настройки
dir="$HOME/.config/rofi/wifi/"
theme='config'

# Функция: получение статуса Wi-Fi
get_status_info() {
    wifi_info=$(nmcli -t -f IN-USE,SSID,SIGNAL,CHAN,FREQ,SECURITY dev wifi list | grep "^*")

    if [ -z "$wifi_info" ];then
        echo -e "Name: Not connected\nAdapter: None\nSignal: N/A\nChannel: N/A\nFrequency: N/A\nSecurity: N/A\nStatus: Disconnected"
        return
    fi

    name=$(echo "$wifi_info" | cut -d: -f2)
    name=${name:-"[Null]"}
    if [ ${#name} -lt 6 ]; then
        name=$(printf "%-8s" "$name")
    fi
    signal=$(echo "$wifi_info" | cut -d: -f3)
    channel=$(echo "$wifi_info" | cut -d: -f4)
    frequency=$(echo "$wifi_info" | cut -d: -f5)
    security=$(echo "$wifi_info" | cut -d: -f6)

    signal_icon=$(
        if [ "$signal" -ge 65 ]; then echo "▁▃▅▇";
        elif [ "$signal" -ge 55 ]; then echo "▁▃▅⎽";
        elif [ "$signal" -ge 40 ]; then echo "▁▃⎽⎽";
        elif [ "$signal" -ge 20 ]; then echo "▁⎽⎽⎽";
        else echo "⎽⎽⎽⎽"; fi
    )

    printf "Name: %-8s [%s]\nSignal: %-20s\nChannel: %-20s\nFrequency: %-20s\nSecurity: %-20s\nStatus: Connected\n" "$name" "$signal_icon" "$signal" "$channel" "$frequency" "$security"
}

# Функция: список доступных сетей
show_networks() {
    connected_network=$(nmcli -t -f IN-USE,SSID,SIGNAL,CHAN,FREQ,SECURITY dev wifi list | grep "^*" | awk -F: '
    {
        name = ($2 == "" || $2 ~ /^\s*$/) ? "[Null]" : $2;
        if (length(name) < 6) {
            name = sprintf("%-8s", name);
        }
    }')

    available_networks=$(nmcli -t -f IN-USE,SSID,SIGNAL,CHAN,FREQ,SECURITY dev wifi list | grep -v "^*" | awk -F: '
    {
        name = ($2 == "" || $2 ~ /^\s*$/) ? "[Null]" : substr($2, 1, 6) (length($2) > 6 ? ".." : "");
        if (length(name) < 6) {
            name = sprintf("%-8s", name);
        }
        signal = ($3 >= 65) ? "▁▃▅▇" : ($3 >= 55) ? "▁▃▅⎽" : ($3 >= 40) ? "▁▃⎽⎽" : ($3 >= 20) ? "▁⎽⎽⎽" : "⎽⎽⎽⎽";
        printf "%-8s %-10s\n", name, signal;
    }')

    echo -e "$available_networks"
}

# Функция: подключение к Wi-Fi
connect_to_network() {
    chosen_network=$(show_networks | rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Select Network:")
    chosen_id=$(echo "$chosen_network" | awk '{print $1}' | sed 's/^[*]//')

    if [ -z "$chosen_id" ]; then
        return
    fi

    if [[ "$chosen_network" == *"(Connected)"* ]]; then
        status=$(get_status_info)
        echo -e "$status\n" | rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Wi-Fi Status" -lines 10
        return
    fi

    # Ввод пароля
    password=$(rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Enter Password:" -lines 0)

    if [ -z "$password" ]; then
        notify-send "Wi-Fi Manager" "Password was not provided."
        return
    fi

    nmcli dev wifi connect "$chosen_id" password "$password" && \
    notify-send "Wi-Fi Manager" "Connected to $chosen_id" || \
    notify-send "Wi-Fi Manager" "Failed to connect to $chosen_id."
}

# Главное меню
main_menu() {
    status=$(get_status_info)
    echo -e "$status\n\n/Connect\n/History" | rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Wi-Fi Manager" -lines 15 | while read tab; do
        case "$tab" in
            "/Connect")
                connect_to_network
                ;;
            "/History")
                saved_networks=$(nmcli -t -f NAME connection show | awk -F: '{print $1}')
                chosen_saved=$(echo -e "$saved_networks" | rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Select Saved Network:")
                chosen_id=$(echo "$chosen_saved" | awk '{print $1}')

                if [ -z "$chosen_saved" ]; then
                    return
                fi

                nmcli connection up id "$chosen_id" && notify-send "Connected" "Connected to $chosen_id"
                ;;
            *)
                notify-send "Wi-Fi Manager" "No valid tab selected. Exiting."
                break
                ;;
        esac
    done
}

main_menu
