-- Убедитесь, что lspconfig загружен
local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
      pythonPath = "./.venv/bin/python",  -- Путь к интерпретатору из venv
    },
  },
  filetypes = { "python" },
  root_dir = lspconfig.util.root_pattern("pyrightconfig.json", ".git", "requirements.txt", "setup.py", "main.py"),
})

