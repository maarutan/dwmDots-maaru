-- leader key 
vim.g.mapleader = " "

-- normal mode saves 
vim.keymap.set("n",  "<C-s>",      ":w<CR>",       { noremap = true, silent = true})
vim.keymap.set("n",  "<C-Return>", ":w<CR>", 	   { noremap = true, silent = true})
 
-- insert mode saves 
vim.keymap.set("i",  "<C-s>",      "<cmd>:w<CR>", { noremap = true, silent = true})
vim.keymap.set("i",  "<C-Return>", "<cmd>:w<CR>", { noremap = true, silent = true})




-- esc 
vim.keymap.set("i",  "jk",         "<Esc>",        { noremap = true, silent = true})

-- neotree normal
vim.keymap.set("n", "<A-e>", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-e>", "<cmd>:Neotree focus filesystem<CR>" , { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-f>", "<cmd>:Neotree focus<CR>" , { noremap = true, silent = true })

vim.keymap.set("i", "<A-e>", "<cmd>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-e>", "<cmd>:Neotree focus filesystem<CR>" , { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-f>", "<cmd>:Neotree focus<CR>" , { noremap = true, silent = true })

-- Переключение фокуса между окнами
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })  -- Фокус на левое окно
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })  -- Фокус на нижнее окно
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })  -- Фокус на верхнее окно
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })  -- Фокус на правое окно

-- Горячая клавиша для вертикального разделения окна: <A-S-w>
vim.api.nvim_set_keymap('n', '<A-S-w>', ':vsplit<CR>', { noremap = true, silent = true })

-- Горячие клавиши для изменения размера окна
vim.api.nvim_set_keymap('n', '<A-S-h>',  ':vertical resize -5<CR>', { noremap = true, silent = true }) -- Уменьшить ширину окна
vim.api.nvim_set_keymap('n', '<A-S-l>', ':vertical resize +5<CR>', { noremap = true, silent = true }) -- Увеличить ширину окна
vim.api.nvim_set_keymap('n', '<A-S-k>',    ':resize -5<CR>', { noremap = true, silent = true })         -- Уменьшить высоту окна
vim.api.nvim_set_keymap('n', '<A-S-j>',  ':resize +5<CR>', { noremap = true, silent = true })         -- Увеличить высоту окна


-- Перемещение строки вверх ввниз
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
-- Перемещение строк вверх в Visual Mode
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })


-- Перемещение строки вправо с Alt + h/l 
vim.api.nvim_set_keymap('n', '<A-l>', '<cmd>normal!>><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', '<cmd>normal!<<<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<A-l>', '<cmd>normal!>gv<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-h>', '<cmd>normal!<gv<CR>', { noremap = true, silent = true })


-- переключение вкладок Shift + j/k
vim.api.nvim_set_keymap('n', '<S-j>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-k>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Terminal
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>')
vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>')
vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical size=40<CR>')

-- Горячая клавиша для закрытия буфера или окна: <C-w>
vim.api.nvim_set_keymap('n', '<C-w>', [[:lua CloseBufferWithNoDelay()<CR>]], { noremap = true, silent = true })

--yazi
vim.keymap.set('n', '<A-y>', ':Yazi<CR>', { noremap = true, silent = true })

-- Переопределение сочетания клавиш S-C-n
vim.keymap.set('n', '<S-C-n>', ':nohl<CR>', { noremap = true, silent = true })

