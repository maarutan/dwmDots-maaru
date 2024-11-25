-- Line numbers
vim.opt.number = true         -- Показывать номера строк
vim.opt.relativenumber = true -- Относительные номера строк

-- Indentation and spacing
vim.opt.tabstop = 4           -- Количество пробелов, соответствующих табуляции
vim.opt.shiftwidth = 4        -- Ширина отступов
vim.opt.expandtab = true      -- Пробелы вместо табуляции
vim.opt.smartindent = true    -- Умное выравнивание

-- Searching
vim.opt.ignorecase = true     -- Игнорировать регистр при поиске
vim.opt.smartcase = true      -- Учитывать регистр, если есть заглавные буквы
vim.opt.hlsearch = true       -- Подсвечивать совпадения
vim.opt.incsearch = true      -- Показывать совпадения по мере ввода

-- UI settings
vim.opt.cursorline = true     -- Подсвечивать строку с курсором
vim.opt.termguicolors = true  -- Использовать 24-битные цвета
vim.opt.signcolumn = "yes"    -- Всегда показывать колонку для знаков
vim.opt.wrap = false          -- Отключить перенос строк

-- Window and tabs
vim.opt.splitright = true     -- Вертикальные окна открываются справа
vim.opt.splitbelow = true     -- Горизонтальные окна открываются снизу

-- Performance
vim.opt.updatetime = 300      -- Время ожидания перед обновлением (мс)
vim.opt.timeoutlen = 500      -- Таймаут для ввода комбинаций клавиш (мс)

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Общий буфер обмена

-- Scrolling
vim.opt.scrolloff = 8         -- Минимальное количество строк сверху/снизу при прокрутке
vim.opt.sidescrolloff = 8     -- Минимальное количество столбцов слева/справа

-- File handling
vim.opt.swapfile = false      -- Отключить swap-файлы
vim.opt.backup = false        -- Не сохранять резервные копии
vim.opt.undofile = true       -- Включить историю изменений
local undodir = vim.fn.stdpath("data") .. "/undo"
if not vim.fn.isdirectory(undodir) then
    vim.fn.mkdir(undodir, "p") -- Создать папку для undo-файлов, если она отсутствует
end
vim.opt.undodir = undodir

-- Encoding
vim.opt.encoding = "utf-8"    -- Установить кодировку интерфейса
vim.opt.fileencoding = "utf-8" -- Установить кодировку для файлов

-- Notifications and short messages
vim.opt.shortmess:append("c") -- Отключить стандартные сообщения о сохранении файла

