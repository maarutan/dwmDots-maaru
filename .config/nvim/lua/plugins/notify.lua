-- Настройка nvim-notify
local notify = require("notify")

notify.setup({
    stages = "fade_in_slide_out",
    timeout = 1500,
    fps = 144,
    icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
})

-- Перехват vim.notify
vim.notify = function(msg, level, opts)
    -- Проверяем, какое сообщение выводится
    if msg:match("written") then
        return -- Пропускаем уведомление о сохранении
    end
    notify(msg, level, opts)
end

