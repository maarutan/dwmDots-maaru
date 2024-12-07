local null_ls = require("null-ls")

local erb_lint = null_ls.builtins.diagnostics.erb_lint.with({
   command = "erb-lint",
   args = { "$FILENAME" },
   filetypes = { "erb", "html" }, -- Поддерживаемые типы файлов
})

return erb_lint
