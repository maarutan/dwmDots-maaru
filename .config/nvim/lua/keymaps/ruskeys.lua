-- Настройка русских клавиш для Neovim
local opts = { noremap = true, silent = true }

-- Перемещение (ролд вместо hjkl)
vim.api.nvim_set_keymap("n", "р", "h", opts)
vim.api.nvim_set_keymap("n", "о", "j", opts)
vim.api.nvim_set_keymap("n", "л", "k", opts)
vim.api.nvim_set_keymap("n", "д", "l", opts)

vim.api.nvim_set_keymap("v", "р", "h", opts)
vim.api.nvim_set_keymap("v", "о", "j", opts)
vim.api.nvim_set_keymap("v", "л", "k", opts)
vim.api.nvim_set_keymap("v", "д", "l", opts)

vim.api.nvim_set_keymap("i", "<C-р>", "<Left>", opts)
vim.api.nvim_set_keymap("i", "<C-о>", "<Down>", opts)
vim.api.nvim_set_keymap("i", "<C-л>", "<Up>", opts)
vim.api.nvim_set_keymap("i", "<C-д>", "<Right>", opts)

-- Вход в режимы
vim.api.nvim_set_keymap("n", "<leader>в", "i", opts) -- Режим вставки
vim.api.nvim_set_keymap("n", "<leader>м", "v", opts) -- Визуальный режим
vim.api.nvim_set_keymap("n", "<leader>р", "R", opts) -- Режим замены
vim.api.nvim_set_keymap("n", "<leader>н", ":terminal<CR>", opts) -- Терминальный режим
