-- Путь к lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Если lazy.nvim еще не установлен, загружаем его
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Последняя стабильная версия
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Загружаем lazy.nvim
require("lazy").setup("plugins.config") -- Подключаем список плагинов

