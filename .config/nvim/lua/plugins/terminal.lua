require("toggleterm").setup({
	open_mapping = [[<C-t>]], -- Открытие терминала через Ctrl-t
	direction = "float", -- Устанавливаем терминал как плавающий
	size = 20, -- Устанавливаем высоту терминала (можно настроить под себя)
	float_opts = {
		border = "rounded", -- Окружность (можно использовать: "single", "double", "rounded", "solid")
		width = 85, -- Устанавливаем ширину терминала
		height = 25, -- Устанавливаем высоту терминала (можно настроить под себя)
	},
})

-- Функция для настройки горячих клавиш в терминале
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 } -- Задаём настройки для текущего буфера

	-- Клавиши для выхода из терминала
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

	-- Клавиши для навигации между окнами
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

	-- Клавиша для работы с окнами
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- Автокоманда для применения настроек терминала при его открытии
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
