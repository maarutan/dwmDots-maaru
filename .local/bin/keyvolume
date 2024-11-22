#!/bin/bash

# Запуск приложения mechvibes в фоновом режиме
mechvibes &

# Получаем PID запущенного приложения
pid=$!

# Даем приложению немного времени для инициализации (по необходимости)
sleep 1

# Проверяем, существует ли процесс mechvibes и завершаем его
if ps -p $pid >/dev/null; then
  kill $pid
  echo "Процесс mechvibes с PID $pid завершён."
else
  echo "Процесс mechvibes не найден."
fi
