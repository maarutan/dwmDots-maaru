require("mason-null-ls").setup({
	ensure_installed = { "black" }, -- Убедись, что black включён
	automatic_installation = true, -- Автоматически подключать инструменты
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.black, -- Использование black для форматирования Python
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			-- Автоматическое форматирование при сохранении
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
