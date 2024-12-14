-- Настройка шрифта с увеличением межбуквенного интервала
vim.o.guifont = "JetBrainsMono Nerd Font:h11:sp2" -- sp2 для увеличения расстояния между символами

-- -- Эффекты курсора (яркие и красивые)
-- vim.g.neovide_cursor_vfx_mode = "railgun" -- Используем яркий эффект Railgun
-- vim.g.neovide_cursor_trail_length = 5.0 -- Длинный след для зрелищности
-- vim.g.neovide_cursor_vfx_particle_lifetime = 1.5 -- Частицы исчезают плавно и дольше
-- vim.g.neovide_cursor_vfx_particle_density = 20.0 -- Высокая плотность частиц для насыщенности
-- vim.g.neovide_cursor_vfx_particle_speed = 8.0 -- Умеренная скорость частиц
-- vim.g.neovide_cursor_animation_length = 0.1 -- Плавная длительная анимация

-- Настройка курсора
vim.o.guicursor = "n-v-c:block-Cursor/lCursor-blinkon800-blinkoff600-blinkwait500,"
	.. "i-ci-ve:ver25-CursorInsert/lCursor-blinkon800-blinkoff600-blinkwait500,"
	.. "r-cr:hor20-CursorReplace/lCursor-blinkon800-blinkoff600-blinkwait500"

-- Скрытие мыши при вводе текста
vim.g.neovide_hide_mouse_when_typing = true

-- Масштабирование интерфейса
vim.g.neovide_scale_factor = 1.0 -- Устанавливает масштаб интерфейса
vim.keymap.set("n", "<C-=>", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, { desc = "Увеличить масштаб" })
vim.keymap.set("n", "<C-->", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, { desc = "Уменьшить масштаб" })

-- Прозрачность окна
vim.g.neovide_transparency = 1.0 -- Устанавливаем лёгкую прозрачность

-- Горячие клавиши для полноэкранного режима
vim.keymap.set("n", "<F11>", function()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = "Переключить полноэкранный режим" })

-- Поддержка Alt+Tab (если Alt блокируется)
vim.g.neovide_input_use_logo = true -- Использовать клавишу "Super" вместо "Alt"

-- Анимация прокрутки
vim.g.neovide_scroll_animation_length = 0.6 -- Добавляем плавность прокрутке

-- Анимация при запуске
-- vim.g.neovide_cursor_vfx_opacity = 0.75 -- Прозрачность эффекта курсора для эстетики
-- vim.g.neovide_no_idle = false -- Курсор "пульсирует", даже когда ничего не происходит
-- vim.g.neovide_remember_window_size = true -- Запоминать размер окна между сессиями

-- Включение 24-битных цветов
vim.o.termguicolors = true
