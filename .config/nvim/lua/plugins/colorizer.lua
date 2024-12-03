-- Устанавливаем плагин colorizer
require('colorizer').setup({
  '*',  -- Применяем ко всем файлам
})

-- Привязываем colorizer к буферу
vim.g.colorizer_attach_to_buffer = 1  -- Включает автоматическое подключение к буферу
-- Для других настроек colorizer
vim.g.colorizer_enable = 1  -- Включает плагин в целом

