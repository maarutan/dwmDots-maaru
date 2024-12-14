local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		require("devlangs.formatters.black"), -- Black для Python
		require("devlangs.formatters.prettier"), -- Prettier для JS/TS/HTML
		require("devlangs.formatters.stylua"), -- Stylua для Lua
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
