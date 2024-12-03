-- Конфигурация для плагина vim-visual-multi
-- visual_multi_config.lua

-- Горячие клавиши для vim-visual-multi
vim.g.VM_maps = {
    -- Поиск под курсором
    ['Find Under']         = '<C-S-d>',  -- Поиск под курсором
    ['Find Subword Under'] = '<C-S-f>', -- Поиск под-слов

    -- Добавление курсоров
    ['Add Cursor Below']   = '<A-S-j>',  -- Добавить курсор ниже
    ['Add Cursor Above']   = '<A-S-k>',  -- Добавить курсор выше
    ['Add Cursor At Pos']  = '<A-S-C-l>',  -- Добавить курсор в текущей позиции

    -- Переключение маппинга для курсоров
    ['Toggle Cursor Mappings'] = '<A-h>',  -- Переключить курсоры
 
    -- Выделить все курсоры
    ['Select All Cursors'] = '<C-a>', -- Выделить все курсоры

    -- Выход из режима мульти-курсора
    ['Escape'] = '<Esc>',    -- Выход из режима
}

-- Настройки горячих клавиш для управления курсорами
vim.keymap.set(
    "n",
    "<leader>I",
    "<A-l><A-h>",  -- Два действия: добавить курсор и переключить маппинг
    { noremap = false, silent = true, desc = "Initial additional cursor " }
)

vim.keymap.set("n", "<A-l>", "<Plug>(VM-Add-Cursor-At-Pos)", { noremap = true, silent = true, desc = "Add cursor at position" })
vim.keymap.set("n", "<A-h>", "<Plug>(VM-Toggle-Mappings)", { noremap = true, silent = true, desc = "Toggle cursor mappings" })
vim.keymap.set("n", "<A-k>", "<Plug>(VM-Add-Cursor-Up)", { noremap = true, silent = true, desc = "Add cursor up" })
vim.keymap.set("n", "<A-j>", "<Plug>(VM-Add-Cursor-Down)", { noremap = true, silent = true, desc = "Add cursor down" })
vim.keymap.set("n", "<C-S-n>", "<Plug>(VM-Select-Next-Word)", { noremap = true, silent = true, desc = "Select next word" })

