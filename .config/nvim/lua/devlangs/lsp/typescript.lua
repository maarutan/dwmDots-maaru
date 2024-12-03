local lspconfig = require("lspconfig")

-- Настройка tsserver для TypeScript и JavaScript
lspconfig.ts_ls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для автодополнения
  settings = {
    -- Можно добавить дополнительные настройки для TypeScript или JavaScript
    javascript = {
      format = {
        semicolons = "insert", -- Добавить точки с запятой
      },
    },
    typescript = {
      format = {
        semicolons = "insert", -- Добавить точки с запятой
      },
    },
  },
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "javascript.jsx", "typescript.tsx" }, -- Поддерживаемые типы файлов
})

