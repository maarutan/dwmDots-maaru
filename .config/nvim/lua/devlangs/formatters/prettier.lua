local null_ls = require("null-ls")

null_ls.setup({
   sources = {
      null_ls.builtins.formatting.prettierd,
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
