require("nvim-ts-autotag").setup()
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = { spacing = 5, min = vim.diagnostic.severity.WARN },
	update_in_insert = true,
})
