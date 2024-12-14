local M = {}

-- Функция для удаления текущего файла и буфера
function M.Delete()
	-- Получаем полный путь к текущему файлу
	local file_path = vim.fn.expand("%:p")
	local buf = vim.fn.bufnr("%")

	-- Проверяем, существует ли буфер
	if buf == -1 or not vim.fn.bufexists(buf) then
		vim.notify("Буфер не существует или уже закрыт.", vim.log.levels.WARN, {
			title = "Delete",
			icon = "⚠️",
		})
		return
	end

	-- Проверяем, связан ли буфер с файлом
	if file_path == "" then
		vim.notify("Буфер не связан с файлом.", vim.log.levels.WARN, {
			title = "Delete",
			icon = "⚠️",
		})
		return
	end

	-- Получаем имя файла
	local file_name = vim.fn.expand("%:t")

	-- Запрашиваем подтверждение
	local answer = vim.fn.input("Удалить файл '" .. file_name .. "'? [y/n]: ")
	if answer:lower() ~= "y" then
		vim.notify("Удаление отменено.", vim.log.levels.WARN, {
			title = "Delete",
			icon = "ℹ️",
		})
		return
	end

	-- Удаляем файл с помощью os.remove
	local ok, err = os.remove(file_path)
	if not ok then
		vim.notify("Ошибка при удалении файла: " .. tostring(err), vim.log.levels.ERROR, {
			title = "Delete",
			icon = "🚨",
		})
		return
	end

	-- Закрываем буфер
	vim.cmd("bwipeout! " .. buf)

	-- Уведомление об успешном удалении
	vim.notify("Файл '" .. file_name .. "' успешно удалён. 💀", vim.log.levels.WARN, {
		title = "Delete",
		icon = "💀",
	})
end

-- Создаём пользовательскую команду Delete
vim.api.nvim_create_user_command("Delete", function()
	M.Delete()
end, { desc = "Удаление текущего файла и буфера с подтверждением" })

-- Привязываем горячую клавишу для команды Delete
vim.keymap.set("n", "<Leader>bD", function()
	M.Delete()
end, { noremap = true, silent = true, desc = "Удалить текущий файл и буфер" })

return M
