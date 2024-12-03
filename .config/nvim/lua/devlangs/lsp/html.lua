local lspconfig = require("lspconfig")

lspconfig.html.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для автодополнения
  settings = {
    html = {
      validate = true, -- Включаем валидацию HTML
      suggest = {
        html5 = true, -- Предложение HTML5-элементов
      },
      formatting = {
        templating = true, -- Включаем форматирование шаблонов
      },
    },
  },
  filetypes = { "html", "htm", "xhtml", "handlebars", "erb", "liquid" }, -- Для работы с несколькими типами файлов
})

