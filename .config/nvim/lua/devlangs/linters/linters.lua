local null_ls = require("null-ls")

local linters = {
   require("devlangs.linters.eslint_d"),
   require("devlangs.linters.flake8"),
   require("devlangs.linters.pylint"),
   require("devlangs.linters.sql_fluff"),
   require("devlangs.linters.stylelint"),
   require("devlangs.linters.erb-lint"), -- Убедись, что файл существует
}

null_ls.setup({
   sources = linters,
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
