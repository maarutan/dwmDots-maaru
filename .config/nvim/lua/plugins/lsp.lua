local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup language servers.
local lspconfig = require("lspconfig")

-- Python LSP
lspconfig.pyright.setup({ capabilities = capabilities })

-- TypeScript LSP (заменён tsserver на ts_ls)
lspconfig.ts_ls.setup({ capabilities = capabilities })

-- Lua LSP
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

-- CSS LSP
lspconfig.cssls.setup({ capabilities = capabilities })

-- HTML LSP
lspconfig.html.setup({ capabilities = capabilities })

-- Global mappings.
vim.keymap.set("n", "<leader>lD", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<Leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
