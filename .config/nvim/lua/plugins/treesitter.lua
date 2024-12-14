require("nvim-treesitter.configs").setup({
	-- Список языков для установки парсеров
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"python",
		"javascript",
		"typescript",
		"html",
		"css",
		"bash",
		"json",
	},

	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
		disable = { "" }, -- optional, list of language that will be disabled
		-- [options]
	},

	-- Асинхронная установка парсеров
	sync_install = false,

	-- Автоматическая установка недостающих парсеров при открытии файла
	auto_install = true,

	-- Языки, для которых не будут установлены парсеры
	ignore_install = { "javascript" },

	highlight = {
		enable = true, -- Включаем подсветку синтаксиса с помощью Tree-sitter
		custom_captures = {
			["keyword"] = "italic", -- Ключевые слова курсивом
			["comment"] = "italic", -- Комментарии курсивом
		},
		-- Отключаем подсветку для определённых языков (если необходимо)
		disable = { "" },

		-- Функция для отключения подсветки для больших файлов (если необходимо)
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Включаем стандартную подсветку синтаксиса для улучшения совместимости с другими плагинами
		additional_vim_regex_highlighting = false,
	},

	-- Опциональные настройки для других функций (например, автоотступы или текстовые объекты)
	indent = {
		enable = true, -- Включаем автоотступы
	},
})
