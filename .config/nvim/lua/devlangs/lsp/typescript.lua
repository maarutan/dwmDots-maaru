local lspconfig = require("lspconfig")

-- Настройка ts_ls для TypeScript и JavaScript
lspconfig.ts_ls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для автодополнения
  on_attach = function(client, bufnr)
    -- Отключение встроенного форматирования, если используешь внешний форматтер (например, Prettier)
    client.server_capabilities.documentFormattingProvider = false

    print("TypeScript LSP подключен к буферу " .. bufnr)
  end,
  settings = {
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
  filetypes = { 
    "typescript", 
    "javascript", 
    "typescriptreact", 
    "javascriptreact", 
    "javascript.jsx", 
    "typescript.tsx" 
  }, -- Поддерживаемые типы файлов
})

