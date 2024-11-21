#!/bin/bash

# Запускаем kitty с нужной командой
kitty --hold -e bash -c "
    sleep 0.5
    xdotool key Super+f; 
    sleep 0.3
    brightnessctl set 1%; 
    peaclock 
    brightnessctl set 50%;"

# Восстанавливаем яркость после закрытия kitty
brightnessctl set 50%
