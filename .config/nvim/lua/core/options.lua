vim.opt.list = true -- Включить отображение listchars
vim.opt.listchars = {
	-- space = "·", -- Символ для пробела
	tab = "│ ", -- Символ для табуляции (настроить при необходимости)
	trail = "→", -- Символ для лишних пробелов
	-- extends = ">", -- Символ для переполнения строки
	-- precedes = "<", -- Символ для текста перед началом строки
}

-- Включение автокоманд для правильной обработки типов файлов
vim.cmd("filetype plugin indent on")
vim.cmd([[autocmd VimEnter * lua require('core.options')]])
vim.opt.cursorline = true -- Подсвечивать строку с курсором

-- vim.o.cursorcolumn = true  -- Включить подсветку столбца с курсором
-- Настройки номеров строк
vim.opt.number = true -- Показывать номера строк
vim.opt.relativenumber = true -- Относительные номера строк

-- Использование пробелов вместо табуляции
vim.opt.expandtab = true -- Преобразовывать табуляцию в пробелы
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

-- Настройка автокоманд для Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4 -- 4 пробела для табуляции
		vim.opt_local.shiftwidth = 4 -- 4 пробела для автоотступа
		vim.opt_local.expandtab = true -- Пробелы вместо табов
	end,
})

-- Поиск
vim.opt.ignorecase = true -- Игнорировать регистр при поиске
vim.opt.smartcase = true -- Учитывать регистр при поиске, если есть заглавные буквы
vim.opt.hlsearch = true -- Подсвечивать совпадения
vim.opt.incsearch = true -- Показывать совпадения по мере ввода

-- Настройки интерфейса
vim.opt.termguicolors = true -- Использовать 24-битные цвета
vim.opt.signcolumn = "yes" -- Всегда показывать колонку для знаков
vim.opt.wrap = false -- Отключить перенос строк

-- Окна и вкладки
vim.opt.splitright = true -- Вертикальные окна открываются справа
vim.opt.splitbelow = true -- Горизонтальные окна открываются снизу

-- Производительность
vim.opt.updatetime = 300 -- Время ожидания перед обновлением (мс)
vim.opt.timeoutlen = 500 -- Таймаут для ввода комбинаций клавиш (мс)

-- Буфер обмена
vim.opt.clipboard = "unnamedplus" -- Общий буфер обмена (система)

-- Прокрутка
vim.opt.scrolloff = 8 -- Минимальное количество строк сверху/снизу при прокрутке
vim.opt.sidescrolloff = 8 -- Минимальное количество столбцов слева/справа при прокрутке

-- Обработка файлов
vim.opt.swapfile = false -- Отключить swap-файлы
vim.opt.backup = false -- Не сохранять резервные копии
vim.opt.undofile = true -- Включить историю изменений
local undodir = vim.fn.stdpath("data") .. "/undo"
if not vim.fn.isdirectory(undodir) then
	vim.fn.mkdir(undodir, "p") -- Создать папку для undo-файлов, если она отсутствует
end
vim.opt.undodir = undodir

-- Оповещения и короткие сообщения
vim.opt.shortmess:append("c") -- Отключить стандартные сообщения о сохранении файла

-- Отключить стандартную подсветку синтаксиса
vim.opt.syntax = "off"
