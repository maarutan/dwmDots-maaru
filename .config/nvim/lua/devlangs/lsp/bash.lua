local lspconfig = require("lspconfig")

-- Настройка bashls для Bash
lspconfig.bashls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Для автодополнения
	on_attach = function(client, bufnr)
		print("Bash LSP подключен к буферу " .. bufnr)
	end,
	settings = {
		bash = {
			shellcheck = {
				enable = true, -- Включить ShellCheck для диагностики
			},
			explainShell = {
				enable = true, -- Включить ExplainShell для пояснений команд
			},
		},
	},
	filetypes = { "sh", "bash" }, -- Поддерживаемые типы файлов
})
