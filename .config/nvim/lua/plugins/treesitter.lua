require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"vim",
		"javascript",
		"typescript",
		"python",
		"css",
		"html",
		"tsx",
		"bash",
	},

	sync_install = false, -- Устанавливать синхронно (true) или асинхронно (false)

	auto_install = true, -- Автоматически устанавливать недостающие парсеры

	-- ignore_install = { 'php', 'lua' }, -- Языки, которые нужно игнорировать при установке

	highlight = {
		enable = true, -- Включить подсветку синтаксиса

		-- disable = { 'markdown' }, -- Отключить подсветку для определённых языков

		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- Максимальный размер файла 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true -- Отключить подсветку для больших файлов
			end
		end,

		additional_vim_regex_highlighting = false, -- Дополнительная подсветка с использованием regex
	},
})
