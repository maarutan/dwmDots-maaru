local null_ls = require("null-ls")

local flake8 = null_ls.builtins.diagnostics.flake8.with({
   command = "flake8",                                                         -- Убедись, что flake8 доступен в PATH
   args = { "--max-line-length=88", "--stdin-display-name", "$FILENAME", "-" }, -- Аргументы для flake8
})

return flake8
