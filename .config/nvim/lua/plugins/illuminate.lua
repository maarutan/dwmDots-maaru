require("illuminate").configure({
	providers = {
		"regex", -- Использовать только регулярные выражения для подсветки
	},
	delay = 200,
	under_cursor = true, -- Подсвечивать слово под курсором
})
