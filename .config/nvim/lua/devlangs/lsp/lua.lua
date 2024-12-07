local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Используется LuaJIT в Neovim
        path = vim.split(package.path, ";"), -- Пути для поиска библиотек
      },
      diagnostics = {
        globals = { "vim" }, -- Не ругаться на глобальную переменную `vim`
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- Подключить файлы Neovim runtime
        checkThirdParty = false, -- Отключить предупреждения о сторонних библиотеках
      },
      telemetry = {
        enable = false, -- Отключить сбор телеметрии
      },
    },
  },
})

