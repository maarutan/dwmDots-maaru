local M = {}

-- Идентификатор последнего уведомления
local last_notification_id = nil

function M.show_file_path()
	-- Получаем полный путь к текущему файлу
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		file_path = "Файл не выбран или не открыт"
	else
		-- Заменяем домашнюю директорию на ~
		file_path = file_path:gsub(vim.env.HOME, "~")
	end

	-- Показываем уведомление с обновлением
	last_notification_id = vim.notify(file_path, vim.log.levels.WARN, {
		title = "Текущий файл",
		replace = last_notification_id, -- Заменяет предыдущее уведомление
		timeout = 3000, -- Уведомление исчезает через 3 секунды
	})
end

-- Назначаем горячую клавишу для вызова
vim.keymap.set(
	"n", -- Normal режим
	"<leader>sf", -- Сочетание клавиш
	M.show_file_path, -- Функция, которая вызывается
	{ noremap = true, silent = true }
)

return M
