#!/bin/sh

# Функция для получения иконки в зависимости от погодного кода
get_icon() {
    case $1 in
        # Icons for weather-icons (все иконки будут одинаковыми)
        01d|01n|02d|02n|03*|04*|09d|09n|10d|10n|11d|11n|13d|13n|50d|50n) icon="";;
        *) icon="  ";;
    esac
    echo $icon
}

# Параметры
KEY="95eceb682535840197b4bbca6483b862"  # Ваш API ключ
CITY="Bishkek,kg"  # Город и страна (Bishkek, Кыргызстан)
UNITS="metric"  # Единицы измерения температуры (метрическая система)
SYMBOL="°"  # Символ для температуры (градусы)

API="https://api.openweathermap.org/data/2.5"  # Базовый URL API OpenWeatherMap

# Цикл для выполнения 900 раз в день (каждую минуту)
for i in {1..900}; do
    # Получаем данные о погоде
    weather=$(curl -sf "$API/weather?q=$CITY&appid=$KEY&units=$UNITS")

    # Проверяем, если данные были получены
    if [ -n "$weather" ]; then
        # Извлекаем температуру и не округляем ее
        weather_temp=$(echo "$weather" | jq ".main.temp")  # Берем температуру с десятичными знаками
        weather_icon=$(echo "$weather" | jq -r ".weather[0].icon")  # Извлекаем иконку погоды

        # Если температура равна -0, заменяем на 0
        if [ "$weather_temp" = "-0" ]; then
            weather_temp="0"
        fi

        # Выводим иконку и температуру с десятичными знаками
        echo "$(get_icon "$weather_icon")  $weather_temp$SYMBOL" > "$HOME/.suckless/scripts/dwmbScripts/.currentsWather"
    else
        echo "Не удалось получить данные о погоде."
    fi

    # Пауза 1 минута (60 секунд)
    sleep 60
done

