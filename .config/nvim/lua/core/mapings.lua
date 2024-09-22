vim.g.mapleader = " "

-- NeoTree
vim.keymap.set('n', '<leader>e', ':Neotree focus<CR>')
vim.keymap.set('n', '<A-e>', ':Neotree toggle<CR>')
vim.keymap.set('n', '<leader>E', ':Neotree float reveal<CR>')
vim.keymap.set('n', '<leader>o', ':Neotree float git_status<CR>')

-- Бинд для сохранения файла
vim.keymap.set('n', '<C-Return>', ':w<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>')


-- Выход из режима вставки в нормальный режим с помощью 'jk'
vim.keymap.set('i', 'jk', '<Esc>')

