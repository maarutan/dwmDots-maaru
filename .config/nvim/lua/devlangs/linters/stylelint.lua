local null_ls = require("null-ls")

local stylelint = null_ls.builtins.diagnostics.stylelint.with({
   command = "stylelint",                -- Убедись, что stylelint доступен
   args = { "--formatter", "json", "--stdin", "--stdin-filename", "$FILENAME" },
   filetypes = { "css", "scss", "less" }, -- Поддерживаемые типы файлов
})

return stylelint
