require("onedark").setup({
	style = "auto", -- Автоматический выбор стиля на основе background
	transparent = false, -- Отключаем прозрачный фон
	term_colors = true, -- Используем цвета терминала
	ending_tildes = false, -- Не отображать тильды (~) в конце буфера
	cmp_itemkind_reverse = false, -- Не изменять порядок значков в nvim-cmp
	code_style = {
		comments = "italic", -- Курсив для комментариев
		keywords = "bold", -- Жирный для ключевых слов
		functions = "italic,bold", -- Курсив + жирный для функций
		strings = "none", -- Обычный стиль для строк
		variables = "none", -- Обычный стиль для переменных
	},
	diagnostics = {
		darker = true, -- Использовать более тёмные цвета для диагностик
		undercurl = true, -- Использовать подчеркивание для диагностик
		background = true, -- Добавить фон для диагностик
	},
})

-- Автоматический выбор стиля в зависимости от background
if vim.o.background == "light" then
	require("onedark").setup({ style = "light" }) -- Светлая тема
else
	require("onedark").setup({ style = "deep" }) -- Тёмная тема
end
