require("smoothcursor").setup({
	type = "matrix", -- Метод вычисления движения курсора. Можно выбрать "default" (по умолчанию), "exp" (экспоненциальный) или "matrix" (матрица).

	cursor = "", -- Форма курсора (нужен Nerd Font). Отключается в режиме fancy.
	texthl = "SmoothCursor", -- Группа подсветки. По умолчанию { bg = nil, fg = "#FFD400" }. Отключается в режиме fancy.
	linehl = nil, -- Подсвечивает строку под курсором, аналогично 'cursorline'. Рекомендуется использовать "CursorLine". Отключается в режиме fancy.

	fancy = {
		enable = false, -- Включить режим fancy
		head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil }, -- false для отключения fancy головы
		body = {
			{ cursor = "󰝥", texthl = "SmoothCursorRed" },
			{ cursor = "󰝥", texthl = "SmoothCursorOrange" },
			{ cursor = "●", texthl = "SmoothCursorYellow" },
			{ cursor = "●", texthl = "SmoothCursorGreen" },
			{ cursor = "•", texthl = "SmoothCursorAqua" },
			{ cursor = ".", texthl = "SmoothCursorBlue" },
			{ cursor = ".", texthl = "SmoothCursorPurple" },
		},
		tail = { cursor = nil, texthl = "SmoothCursor" }, -- false для отключения fancy хвоста
	},

	matrix = { -- Загружается, если 'type' установлен в "matrix"
		head = {
			-- Случайный символ для текста курсора
			cursor = require("smoothcursor.matrix_chars"),
			-- Случайная подсветка для текста курсора
			texthl = {
				"SmoothCursor",
			},
			linehl = nil, -- Нет подсветки для головы
		},
		body = {
			length = 6, -- Длина тела курсора
			-- Случайный символ для текста тела курсора
			cursor = require("smoothcursor.matrix_chars"),
			-- Случайная подсветка для каждого сегмента тела курсора
			texthl = {
				"SmoothCursorGreen",
			},
		},
		tail = {
			-- Случайный символ для текста хвоста курсора (если есть)
			cursor = nil,
			-- Случайная подсветка для хвоста курсора
			texthl = {
				"SmoothCursor",
			},
		},
		unstop = true, -- Определяет, должен ли курсор останавливаться (false — он будет останавливаться)
	},

	autostart = true, -- Автоматически запускать SmoothCursor
	always_redraw = false, -- Перерисовывать экран на каждом обновлении
	flyin_effect = "top", -- Эффект "влетания", можно выбрать "bottom" или "top"
	speed = 40, -- Максимальная скорость, 100 — это максимальная для фиксированного положения
	intervals = 20, -- Интервалы обновлений в миллисекундах
	priority = 10, -- Приоритет маркера
	timeout = 4000, -- Тайм-аут для анимаций в миллисекундах
	threshold = 1, -- Анимировать, только если курсор перемещается больше, чем на это количество строк
	max_threshold = nil, -- Если переместить курсор больше, чем на это количество строк, анимация не будет (если nil, проверка деактивирована)
	disable_float_win = false, -- Отключить в плавающих окнах
	enabled_filetypes = nil, -- Включить только для определенных типов файлов, например { "lua", "vim" }
	disabled_filetypes = nil, -- Отключить для этих типов файлов, игнорируется, если установлены enabled_filetypes. Например { "TelescopePrompt", "NvimTree" }
	show_last_positions = "enter", -- Показать позицию последнего ввода. Значение "enter" обновляет позицию при входе в режим, "leave" — при выходе. `nil` — отключено
})
