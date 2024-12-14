-- Установка глобальной переменной для отслеживания текущей темы
vim.g.is_day_mode = vim.o.background == "light"

require("bufferline").setup({
	options = {
		numbers = "none",
		close_command = "bdelete",
		right_mouse_command = "bdelete!",
		left_mouse_command = "buffer",
		middle_mouse_command = nil,
		indicator = {
			icon = "▎", -- Тонкий индикатор активного буфера
			style = "icon",
		},
		buffer_close_icon = "  ", -- Крестик для закрытия буфера
		modified_icon = "[󰐕]", -- Индикатор несохранённых изменений
		close_icon = "  ", -- Глобальная кнопка закрытия всех буферов
		left_trunc_marker = "«",
		right_trunc_marker = "»",
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return icon .. count
		end,
		offsets = {
			{
				filetype = "neo-tree",
				text = function()
					return require("pacman").get_pacman_text()
				end,
				text_align = "center",
				separator = true,
			},
		},
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_tab_indicators = true,
		enforce_regular_tabs = false, -- автоматическая подстройка ширины
		always_show_bufferline = true,
		separator_style = "thin", -- минималистичный стиль
		custom_areas = {
			right = function()
				local mode = vim.g.is_day_mode and "   󰖨  ▎" or "     ▎"
				return {
					{ text = mode, padding = 1 },
					{ text = "🌊🌊🌊 " },
					{
						text = "  ",
						fg = "#FFFFFF",
						bg = "#FF5F5F",
						padding = 1,
					},
				}
			end,
		},
	},
	-- Удаляем highlights, чтобы использовать цвета по умолчанию
})

-- Переключение между светлой и тёмной темой с dynamic source
vim.keymap.set("n", "<leader>tn", function()
	-- Динамический путь к файлу colorscheme.lua
	local colorscheme_path = vim.fn.stdpath("config") .. "/lua/core/colorscheme.lua"

	-- Переключаем режим темы
	vim.g.is_day_mode = not vim.g.is_day_mode

	-- Устанавливаем фон в зависимости от режима
	if vim.g.is_day_mode then
		vim.o.background = "light"
		vim.notify("Смена темы: День ", vim.log.levels.WARN, { title = "Тема" })
	else
		vim.o.background = "dark"
		vim.notify("Смена темы: Ночь ", vim.log.levels.WARN, { title = "Тема" })
	end

	-- Выполняем source для файла colorscheme.lua
	vim.cmd("source " .. colorscheme_path)
end, { desc = "Переключение темы День/Ночь" })

-- Закрытие всех буферов
vim.keymap.set("n", "<leader>ba", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
			vim.cmd("bdelete " .. buf)
		end
	end
	vim.notify("Все буферы закрыты", vim.log.levels.WARN, { title = "Bufferline" })
end, { desc = "Закрыть все буферы" })
