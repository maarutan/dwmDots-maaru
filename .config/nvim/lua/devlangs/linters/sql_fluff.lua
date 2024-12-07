local null_ls = require("null-ls")

local sql_fluff = null_ls.builtins.diagnostics.sqlfluff.with({
	command = "sqlfluff", -- Убедись, что sqlfluff доступен в PATH
	args = { "lint", "-" },
	filetypes = { "sql" },
	extra_args = { "--dialect", "ansi" }, -- Укажи диалект SQL
})

return sql_fluff
