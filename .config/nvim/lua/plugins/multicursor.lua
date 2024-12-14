-- Включение подсветки совпадений
vim.g.VM_highlight_matches = "underline" -- Стиль отображения
vim.g.VM_cursor = "block" -- Установить курсор-блок во всех режимах
vim.g.VM_set_statusline = 0 -- Отключает обновление статусной строки в vim-visual-multi
vim.g.VM_silent_exit = 1 -- Отключает сообщения при выходе из режима мультикурсов

-- Установить тему для vim-visual-multi
vim.cmd("VMTheme auto")

-- Настройки горячих клавиш для vim-visual-multi
vim.g.VM_maps = {
	-- Добавление курсоров вверх и вниз
	["Add Cursor Below"] = "<S-C-j>", -- Добавить курсор ниже
	["Add Cursor Above"] = "<S-C-k>", -- Добавить курсор выше

	-- Добавление курсора в текущую позицию
	["Add Cursor At Pos"] = "<S-C-l>", -- Добавить курсор в текущей позиции

	-- Выбрать все совпадения в документе
	["Select All"] = "<A-S-a>", -- Выбрать все совпадения

	-- Поиск слов в текущей строкеmulti
	["Find Under"] = "<A-S-d>", -- Найти слово под курсором и двигаться вниз
	["Find Prev"] = "<A-S-u>", -- Найти слово под курсором и двигаться вверх

	-- Пропуск курсора при поиске
	["Skip Region"] = "<A-S-s>", -- Пропустить текущее слово

	-- Навигация с использованием hjkl
	["Move Left"] = "h",
	["Move Down"] = "j",
	["Move Up"] = "k",
	["Move Right"] = "l",
}

vim.keymap.set(
	"n",
	"<A-S-d>",
	"<Plug>(VM-Find-Under)",
	{ noremap = true, silent = true, desc = "Найти слово под курсором" }
)
-- Привязка дополнительных клавиш
vim.keymap.set(
	"n",
	"<S-C-l>",
	"<Plug>(VM-Add-Cursor-At-Pos)",
	{ noremap = true, silent = true, desc = "Добавить курсор в текущую позицию" }
)
vim.keymap.set(
	"n",
	"<S-C-j>",
	"<Plug>(VM-Add-Cursor-Down)",
	{ noremap = true, silent = true, desc = "Добавить курсор ниже" }
)
vim.keymap.set(
	"n",
	"<S-C-k>",
	"<Plug>(VM-Add-Cursor-Up)",
	{ noremap = true, silent = true, desc = "Добавить курсор выше" }
)
vim.keymap.set(
	"n",
	"<CR>",
	"<Plug>(VM-Toggle-Mappings)",
	{ noremap = true, silent = true, desc = "Переключить режим мульти-курсоров" }
)
vim.keymap.set(
	"n",
	"<A-S-a>",
	"<Plug>(VM-Select-All)",
	{ noremap = true, silent = true, desc = "Выбрать все совпадения в документе" }
)
vim.keymap.set("n", "<A-S-u>", "<Plug>(VM-Select-Prev)", {
	noremap = true,
	silent = true,
	desc = "Найти предыдущее совпадение и двигаться вверх",
})
vim.keymap.set(
	"n",
	"<A-S-s>",
	"<Plug>(VM-Skip-Region)",
	{ noremap = true, silent = true, desc = "Пропустить текущую область при поиске" }
)
