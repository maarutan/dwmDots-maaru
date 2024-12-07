local luasnip = require('luasnip')

-- Добавляем сниппет для JSON с конфигурацией Pyright
luasnip.add_snippets("json", {
  luasnip.snippet("pyrightconfig", {  -- Триггер "pyrightconfig"
    luasnip.text_node({
      "{",
      "  \"venvPath\": \"./.venv\",",
      "  \"pythonVersion\": \"3.8\",",
      "  \"include\": [\"src\"],",
      "  \"exclude\": [\"node_modules\", \".git\"],",
      "  \"reportMissingImports\": true,",
      "  \"reportGeneralTypeIssues\": true",
      "}"
    })
  })
})
