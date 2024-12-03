local lspconfig = require("lspconfig")

lspconfig.cssls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для автодополнения
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
  filetypes = { "css", "scss", "less", "html", "javascriptreact", "typescriptreact" }, -- Для работы с несколькими типами файлов
})

