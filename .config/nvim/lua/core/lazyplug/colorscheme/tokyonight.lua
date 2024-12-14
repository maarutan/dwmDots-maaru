require("tokyonight").setup({
	style = "auto", -- Автоматический выбор стиля
	light_style = "night", -- Устанавливаем дневной стиль
	transparent = false, -- Прозрачность отключена
	terminal_colors = true, -- Использовать цвета терминала
	styles = {
		comments = { italic = true }, -- Курсив для комментариев
		keywords = { italic = true }, -- Курсив для ключевых слов
		functions = { bold = true }, -- Жирный для функций
		variables = {}, -- Обычный стиль для переменных
	},
	sidebars = { "qf", "help", "terminal", "packer" }, -- Прозрачность боковых панелей
	dim_inactive = false, -- Не затемнять неактивные окна
	lualine_bold = true, -- Жирный текст в lualine
})

-- Автоматический выбор стиля в зависимости от background
if vim.o.background == "light" then
	vim.cmd("colorscheme tokyonight-day")
else
	vim.cmd("colorscheme tokyonight-night")
end
