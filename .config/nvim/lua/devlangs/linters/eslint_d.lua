local null_ls = require("null-ls")

local eslint_d = null_ls.builtins.diagnostics.eslint_d.with({
   command = "eslint_d",                                 -- Команда для запуска eslint_d
   args = { "--stdin", "--stdin-filename", "$FILENAME" }, -- Аргументы для работы через stdin
})

return eslint_d
