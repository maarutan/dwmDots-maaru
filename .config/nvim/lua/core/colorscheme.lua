-- colorscheme.lua

--------------------------------------------------------
-- Настройка для Catppuccin
--------------------------------------------------------
vim.g.catppuccin_flavour = "mocha" -- Опции: "latte", "frappe", "macchiato", "mocha"
vim.cmd([[colorscheme catppuccin]])

--------------------------------------------------------
-- Настройка для Gruvbox
--------------------------------------------------------
-- vim.cmd([[colorscheme gruvbox]])

--------------------------------------------------------
-- Настройка для Tokyonight
--------------------------------------------------------
-- vim.cmd([[colorscheme tokyonight-night]])  -- Тема ночь
-- vim.cmd([[colorscheme tokyonight-storm]])  -- Тема шторм
-- vim.cmd([[colorscheme tokyonight-day]])    -- Тема день
-- vim.cmd([[colorscheme tokyonight-moon]])   -- Тема луна

--------------------------------------------------------
-- Настройка для One Dark
--------------------------------------------------------
require("onedark").setup({
	style = "deep", -- Опции: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
})
-- vim.cmd([[colorscheme onedark]])

--------------------------------------------------------
-- Настройка для Kanagawa
--------------------------------------------------------
-- vim.cmd("colorscheme kanagawa-wave")    -- Волн
-- vim.cmd("colorscheme kanagawa-dragon")  -- Дракон
-- vim.cmd("colorscheme kanagawa-lotus")   -- Лотос

--------------------------------------------------------
-- Настройка для GitHub
--------------------------------------------------------
-- vim.cmd([[colorscheme github_dark]])           -- Темная схема GitHub
-- vim.cmd([[colorscheme github_light]])          -- Светлая схема GitHub
-- vim.cmd([[colorscheme github_dark_dimmed]])   -- Темная приглушенная схема
-- vim.cmd([[colorscheme github_dark_default]])  -- Стандартная темная схема GitHub
-- vim.cmd([[colorscheme github_light_default]]) -- Стандартная светлая схема GitHub
-- vim.cmd([[colorscheme github_dark_high_contrast]])  -- Темная схема с высоким контрастом
-- vim.cmd([[colorscheme github_light_high_contrast]]) -- Светлая схема с высоким контрастом
-- vim.cmd([[colorscheme github_dark_colorblind]])  -- Темная схема для дальтоников (Протанопия и Дейтеранопия)
-- vim.cmd([[colorscheme github_light_colorblind]]) -- Светлая схема для дальтоников (Протанопия и Дейтеранопия)
-- vim.cmd([[colorscheme github_dark_tritanopia]])  -- Темная схема для дальтоников (Тританопия)
-- vim.cmd([[colorscheme github_light_tritanopia]]) -- Светлая схема для дальтоников (Тританопия)

--------------------------------------------------------
-- Настройка для VSCode
--------------------------------------------------------
-- require('vscode').load('light')  -- Светлая тема для VSCode
-- require('vscode').load('dark')   -- Темная тема для VSCode

--------------------------------------------------------
-- Настройка для Nightfox
--------------------------------------------------------
require("nightfox").setup({
	style = "nightfox", -- Возможные стили: "nightfox", "dayfox", "dawnfox", "nordfox", "terafox"
})
-- vim.cmd([[colorscheme dayfox]])  -- Активируем Nightfox тему
