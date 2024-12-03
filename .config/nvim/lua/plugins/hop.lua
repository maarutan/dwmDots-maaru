-- myconfig.lua (или config.lua)

require('hop').setup({
    keys = 'etovxqpdygfblzhckisuranmw',  -- Настройте клавиши поиска, можете выбрать любые
    hint_position = 'center',           -- Подсказки по центру экрана
    jump_on_sole_occurrence = true,     -- Перемещение сразу, если одно совпадение
    case_insensitive = true,           -- Игнорировать регистр
    hint_animation = false,            -- Отключение анимации
    create_hl_autocmd = false,         -- Отключение автокоманд для подсветки текста
})

-- Горячие клавиши для поиска
vim.api.nvim_set_keymap('n', '<leader>w', "<cmd>lua require'hop'.hint_words()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>s', "<cmd>lua require'hop'.hint_char1()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require'hop'.hint_char2()<CR>", { noremap = true, silent = true })
