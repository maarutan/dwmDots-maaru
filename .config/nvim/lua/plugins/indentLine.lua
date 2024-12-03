-- Настройка ibl (Indent Blankline)
require("ibl").setup({
    indent = {
        char = "│", -- Символ для отображения линий
    },
    scope = {
        enabled = false, -- Отключаем подсветку области для ibl
    },
    exclude = {
        filetypes = { "dashboard" }, -- Исключаем файлы
    },
})

-- Настраиваем тусклый цвет для ibl
vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#3e4451", nocombine = true })

-- Настройка mini.indentscope
require("mini.indentscope").setup({
  -- Настройки отображения
  draw = {
    delay = 100, -- Задержка перед началом отрисовки индикатора

    -- Плавная анимация
    animation = require("mini.indentscope").gen_animation.linear({
      easing = "in-out",  -- Плавная анимация
      duration = 25,      -- Длительность анимации
      unit = "step",      -- Шаги анимации
    }),

    -- Приоритет символа
    priority = 2,
  },

  -- Горячие клавиши
  mappings = {
    object_scope = 'ii',
    object_scope_with_border = 'ai',
    goto_top = '[i',
    goto_bottom = ']i',
  },

  -- Опции для вычисления области
  options = {
    border = 'both',         -- Отображение верхней и нижней границ области
    indent_at_cursor = true, -- Использовать отступ на позиции курсора
    try_as_border = false,   -- Не рассматривать текущую строку как границу области
  },

  -- Символ для отображения индикатора
  symbol = "│",
})

-- Добавляем игнорирование для mini.indentscope
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dashboard", "help", "NvimTree", "lazy", "terminal" }, -- Список типов файлов для игнорирования
  callback = function()
    vim.b.miniindentscope_disable = true -- Отключение mini.indentscope для текущего буфера
  end,
})

