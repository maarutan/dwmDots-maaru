-- ~/.config/nvim/lua/plugins/cowboy.lua
local M = {}

function M.cowboy()
	---@type table?
	local id
	local ok = true
	for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
		local count = 0
		local timer = assert(vim.loop.new_timer())
		local map = key
		vim.keymap.set("n", key, function()
			if vim.v.count > 0 then
				count = 0  -- сброс счётчика, если используется префиксный аргумент (например, 3h)
			end
			if count >= 10 then
				-- Когда количество нажатий превышает 10, показывается предупреждение
				ok, id = pcall(vim.notify, "       Hold it Cowboy!       ", vim.log.levels.WARN, {
					icon = "       🤠",  -- Иконка для уведомления
					replace = id,  -- Заменяет предыдущее уведомление, если оно ещё активно
					keep = function()
						return count >= 10  -- Уведомление будет показываться, пока количество нажатий >= 10
					end,
				})
				if not ok then
					id = nil  -- Если произошла ошибка с уведомлением, сбрасываем id
					return map  -- Возвращаем исходное назначение клавиши
				end
			else
				count = count + 1  -- Увеличиваем счётчик
				-- Запускаем таймер, чтобы сбросить счётчик после 2 секунд без нажатий
				timer:start(2000, 0, function()
					count = 0
				end)
				return map  -- Возвращаем исходное назначение клавиши
			end
		end, { expr = true, silent = true })  -- `expr` для обработки возврата клавиши как команды
	end
end

-- Вызываем функцию cowboy() автоматически при подключении
M.cowboy()

return M

