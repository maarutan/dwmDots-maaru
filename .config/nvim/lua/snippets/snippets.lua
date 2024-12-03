-- lua/config/luasnip.lua
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load() -- Загрузка сниппетов из расширений VSCode

-- Настройка сниппетов (если нужно, можно настроить свои)
luasnip.config.set_config({
  history = true, -- История переходов в сниппетах
  updateevents = "TextChanged,TextChangedI", -- Обновление сниппетов при изменении текста
})

-- Пример простого сниппета
luasnip.add_snippets("lua", {
    luasnip.snippet("fn", {
        luasnip.text_node("function "),
        luasnip.insert_node(1, "name"),
        luasnip.text_node("()"),
        luasnip.insert_node(0),
        luasnip.text_node("end"),
    })
})

return luasnip

