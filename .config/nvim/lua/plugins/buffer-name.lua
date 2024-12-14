local M = {}

-- Функция для переименования текущего буфера и файла
function M.rename()
	-- Получаем текущий полный путь к файлу
	local current_path = vim.fn.expand("%:p")
	if current_path == "" or vim.fn.filereadable(current_path) == 0 then
		vim.notify(
			"Ошибка: Файл не существует или не связан с буфером.",
			vim.log.levels.ERROR,
			{
				icon = "🚨",
				title = "BufferRename",
			}
		)
		return
	end

	-- Запрашиваем новое имя
	local new_name = vim.fn.input("New name for buffer: ", vim.fn.expand("%:t"))
	if new_name == "" or new_name == vim.fn.expand("%:t") then
		vim.notify("Переименование отменено.", vim.log.levels.WARN, {
			icon = "ℹ️",
			title = "BufferRename",
		})
		return
	end

	-- Создаем полный путь для нового файла
	local new_path = vim.fn.fnamemodify(current_path, ":h") .. "/" .. new_name

	-- Пытаемся переименовать файл
	local ok, err = os.rename(current_path, new_path)
	if not ok then
		vim.notify("Ошибка при переименовании файла: " .. err, vim.log.levels.ERROR, {
			icon = "🚨",
			title = "BufferRename",
		})
		return
	end

	-- Сохраняем номер текущего буфера
	local current_buf = vim.fn.bufnr("%")

	-- Открываем новый файл в текущем буфере
	vim.cmd("edit " .. new_path)

	-- Проверяем, существует ли старый буфер перед удалением
	if vim.fn.bufexists(current_buf) == 1 then
		vim.cmd("bwipeout " .. current_buf)
	end

	-- Уведомляем об успешном переименовании
	vim.notify("Файл успешно переименован в: " .. new_name, vim.log.levels.WARN, {
		icon = "✅",
		title = "BufferRename",
	})
end

-- Создаем пользовательскую команду для вызова функции переименования
vim.api.nvim_create_user_command("Rename", function()
	M.rename()
end, { desc = "Rename current buffer's file" })

-- Привязываем горячие клавиши для вызова функции
vim.keymap.set("n", "<Leader>br", function()
	M.rename()
end, { noremap = true, silent = true, desc = "Rename buffer" })

return M
