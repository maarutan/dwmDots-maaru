local M = {}

-- Функция для создания нового буфера
function M.create_new_buffer()
	-- Запрашиваем имя для нового файла
	local new_name = vim.fn.input("New file name: ", "")
	if new_name == "" then
		vim.notify("Создание буфера отменено.", vim.log.levels.WARN, {
			icon = "ℹ️",
			title = "NewBuffer",
		})
		return
	end

	-- Проверяем, существует ли файл
	if vim.fn.filereadable(new_name) == 1 then
		vim.notify("Ошибка: Файл уже существует.", vim.log.levels.ERROR, {
			icon = "🚨",
			title = "NewBuffer",
		})
		return
	end

	-- Создаём новый буфер, связанный с файлом
	local ok, err = pcall(function()
		vim.cmd("edit " .. new_name)
		vim.cmd("setlocal buftype=") -- Устанавливаем обычный тип буфера
	end)

	if not ok then
		vim.notify("Ошибка при создании буфера: " .. err, vim.log.levels.ERROR, {
			icon = "🚨",
			title = "NewBuffer",
		})
		return
	end

	-- Уведомление об успешном создании
	vim.notify("Новый буфер успешно создан: " .. new_name, vim.log.levels.WARN, {
		icon = "✅",
		title = "NewBuffer",
	})
end

-- Создаем пользовательскую команду для создания нового буфера
vim.api.nvim_create_user_command("NewBuffer", function()
	M.create_new_buffer()
end, { desc = "Create a new buffer and associate with a file" })

-- Привязываем горячие клавиши для вызова функции
vim.keymap.set("n", "<Leader>bn", function()
	M.create_new_buffer()
end, { noremap = true, silent = true, desc = "Create new buffer" })

return M
