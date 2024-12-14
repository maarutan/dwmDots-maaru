-- leader key
vim.g.mapleader = " "

-- normal mode saves
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Return>", ":w<CR>", { noremap = true, silent = true })

-- insert mode saves
vim.keymap.set("i", "<C-s>", "<cmd>:w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-Return>", "<cmd>:w<CR>", { noremap = true, silent = true })

-- esc
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- neotree normal
vim.keymap.set("n", "<A-e>", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-e>", "<cmd>:Neotree focus filesystem<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-f>", "<cmd>:Neotree focus<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<A-e>", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-e>", "<cmd>:Neotree focus filesystem<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-f>", "<cmd>:Neotree focus<CR>", { noremap = true, silent = true })

-- Переключение фокуса между окнами
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true }) -- Фокус на левое окно
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true }) -- Фокус на нижнее окно
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true }) -- Фокус на верхнее окно
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true }) -- Фокус на правое окно

-- Горячая клавиша для вертикального разделения окна: <A-S-w>
vim.api.nvim_set_keymap("n", "<A-S-w>", ":vsplit<CR>", { noremap = true, silent = true })

-- Горячие клавиши для изменения размера окна
vim.api.nvim_set_keymap("n", "<A-S-h>", ":vertical resize -5<CR>", { noremap = true, silent = true }) -- Уменьшить ширину окна
vim.api.nvim_set_keymap("n", "<A-S-l>", ":vertical resize +5<CR>", { noremap = true, silent = true }) -- Увеличить ширину окна
vim.api.nvim_set_keymap("n", "<A-S-k>", ":resize -5<CR>", { noremap = true, silent = true }) -- Уменьшить высоту окна
vim.api.nvim_set_keymap("n", "<A-S-j>", ":resize +5<CR>", { noremap = true, silent = true }) -- Увеличить высоту окна

-- Перемещение строки вверх ввниз
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
-- Перемещение строк вверх в Visual Mode
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Перемещение строки вправо с Alt + h/l
vim.api.nvim_set_keymap("n", "<A-l>", "<cmd>normal!>><CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-h>", "<cmd>normal!<<<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<A-l>", "<cmd>normal!>gv<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-h>", "<cmd>normal!<gv<CR>", { noremap = true, silent = true })

-- переключение вкладок Shift + j/k
vim.api.nvim_set_keymap("n", "<S-j>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-k>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

-- Terminal
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical size=40<CR>")

-- Горячая клавиша для закрытия буфера или окна: <C-w>
vim.api.nvim_set_keymap("n", "<leader>bd", ":Bdelete<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bbd", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-q>", ":q!<CR>", { noremap = true, silent = true })

--yazi
vim.keymap.set("n", "<A-y>", ":Yazi<CR>", { noremap = true, silent = true })

-- Переопределение сочетания клавиш S-C-n
vim.keymap.set("n", "<S-C-n>", ":nohl<CR>", { noremap = true, silent = true })

-- работа с вкладками
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", ":tabNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { noremap = true, silent = true })

-- выбрать все в NORMALMODE
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", "GVgg", { noremap = true, silent = true })
-- выбрать все в INSERTMODE
vim.keymap.set("i", "<C-q>", "<Esc>GVggi", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVGi", { noremap = true, silent = true })

-- удалять на 1 слово назад и назад
vim.keymap.set("i", "<C-BS>", "<Esc>vbdi", { noremap = true, silent = true })
vim.keymap.set("i", "<C-Del>", "<Esc>vedi", { noremap = true, silent = true })

-- Нормальный режим: x выполняет функции d
vim.keymap.set("n", "x", "d", { desc = "Полностью заменить x на d" })

-- Визуальный режим: x выполняет функции d
vim.keymap.set(
	"v",
	"x",
	"d",
	{ desc = "Полностью заменить x на d в визуальном режиме" }
)

-- Удаление строки: xx выполняет функции dd
vim.keymap.set("n", "xx", "dd", { desc = "Удалить строку как dd" })

--новый там + открытые в нем терминалы
vim.keymap.set("n", "<leader>tT", ":tabnew | terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>T", ":term<CR>", { noremap = true, silent = true })

--reload
vim.keymap.set("n", "C-S-r", "so $MYVIMRC<CR>", { noremap = true, silent = true })

-- -- system command
-- vim.keymap.set("n", "<C-c>", '"+y', { noremap = true, silent = true })
-- vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
-- vim.keymap.set("i", "<C-v>", '<Esc>"+pa', { noremap = true, silent = true })
-- vim.keymap.set("c", "<C-v>", "<C-r>+", { noremap = true, silent = true })
-- vim.keymap.set("c", "<C-v>", "<C-r>+", { noremap = true, silent = true })
-- vim.keymap.set("v", "<C-S-c>", '"+y')
-- vim.keymap.set("n", "<C-S-c>", '"+yy')
-- vim.keymap.set("i", "<C-S-v>", "<C-r>+")
-- vim.keymap.set("n", "<C-S-v>", '"+p')
-- vim.keymap.set("v", "<C-S-v>", '"+p')
--
--commands
vim.cmd([[
    cnoremap <C-j> <C-n>
    cnoremap <C-k> <C-p>
]])

vim.keymap.set("n", "<leader>oc", function()
	vim.cmd("edit ~/.config/nvim/init.lua")
end, { noremap = true, silent = true, desc = "Открыть init.lua" })
vim.keymap.set("n", "l", "<right>", { noremap = true, silent = true })
vim.keymap.set("v", "l", "<right>", { noremap = true, silent = true })
