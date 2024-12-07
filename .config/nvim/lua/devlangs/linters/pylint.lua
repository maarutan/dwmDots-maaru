local null_ls = require("null-ls")

local pylint = null_ls.builtins.diagnostics.pylint.with({
	command = "pylint", -- Команда для запуска pylint
	args = { "--from-stdin", "$FILENAME" }, -- Аргументы для stdin
	filetypes = { "python" },
})

return pylint
