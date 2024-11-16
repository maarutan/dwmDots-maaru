-- Маппинги клавиш для всех режимов
local opts = { noremap = true, silent = true }

-- Маппинг Ctrl + Enter для всех режимов
vim.api.nvim_set_keymap("n", "<C-Return>", ":w<CR>", opts) -- Нормальный режим
vim.api.nvim_set_keymap("i", "<C-Return>", "<Esc>:w<CR>i", opts) -- Режим вставки
vim.api.nvim_set_keymap("v", "<C-Return>", ":w<CR>", opts) -- Визуальный режим
vim.api.nvim_set_keymap("t", "<C-Return>", "<C-\\><C-n>:w<CR>", opts) -- Терминальный режим

-- Маппинг Ctrl + S для всех режимов
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", opts) -- Нормальный режим
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>i", opts) -- Режим вставки
vim.api.nvim_set_keymap("v", "<C-s>", ":w<CR>", opts) -- Визуальный режим
vim.api.nvim_set_keymap("t", "<C-s>", "<C-\\><C-n>:w<CR>", opts) -- Терминальный режим

-- Маппинг <leader>w для всех режимов
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", opts) -- Нормальный режим
vim.api.nvim_set_keymap("v", "<leader>w", ":w<CR>", opts) -- Визуальный режим
vim.api.nvim_set_keymap("t", "<leader>w", "<C-\\><C-n>:w<CR>", opts) -- Терминальный режим

-- Маппинг jk jj для выхода из режима вставки
vim.api.nvim_set_keymap("i", "jk", "<Esc>", opts)
vim.api.nvim_set_keymap("i", "jj", "<Esc>", opts)
--------------------------------------------------------
