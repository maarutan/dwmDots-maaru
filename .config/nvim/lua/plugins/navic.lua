local navic = require("nvim-navic")

require("lspconfig").<your_lsp_server>.setup {
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end,
}

