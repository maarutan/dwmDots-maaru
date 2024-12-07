local lspconfig = require("lspconfig")

lspconfig.cssls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для интеграции с автодополнением через nvim-cmp
  settings = {
    css = {
      validate = true, -- Включить валидацию CSS
    },
    scss = {
      validate = true, -- Включить валидацию SCSS
    },
    less = {
      validate = true, -- Включить валидацию Less
    },
  },
  filetypes = { "css", "scss", "less", "html", "javascriptreact", "typescriptreact" }, -- Поддерживаемые типы файлов
  root_dir = lspconfig.util.root_pattern("package.json", ".git", "node_modules"), -- Определение корня проекта
})

