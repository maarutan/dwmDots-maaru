require("nvim-listchars").setup({
	save_state = true,
	listchars = {
		trail = "·", -- Изменен на '*'
		eol = "↲", -- Изменен на '↳'
		tab = "│ ", -- Изменен на '➔'
	},
	exclude_filetypes = { "markdown" },
	lighten_step = 10,
})
