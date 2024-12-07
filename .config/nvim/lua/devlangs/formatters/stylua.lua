local null_ls = require("null-ls")

null_ls.register({
	null_ls.builtins.formatting.stylua.with({
		command = "stylua",
		args = {
			"--stdin-filepath",
			"$FILENAME",
			"--",
			"-",
		},
		filetypes = { "lua" }, -- Поддерживаемый тип файлов
	}),
})
